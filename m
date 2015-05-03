From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v2 5/5] nilfs-utils: add support for greedy/cost-benefit policies
Date: Sun,  3 May 2015 12:07:07 +0200
Message-ID: <1430647627-18902-5-git-send-email-andreas.rohner@gmx.net>
References: <1430647522-14304-1-git-send-email-andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430647522-14304-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This patch implements the cost-benefit and greedy GC policies. These ar=
e
well known policies for log-structured file systems [1].

* Greedy:
  Select the segments with the most reclaimable space.
* Cost-Benefit [1]:
  Perform a cost-benefit analysis, whereby the reclaimable space
  gained is weighed against the cost of collecting the segment.

Since especially cost-benefit needs more information than is available
in nilfs_suinfo, a few extra parameters are added to the policy callbac=
k
function prototype. The flag p_comparison is added to indicate how the
importance values should be interpreted. For example for the timestamp
policy smaller values mean older timestamps, which is better. For greed=
y
and cost-benefit on the other hand, higher values are better.
nilfs_cleanerd_select_segments() was updated accordingly.

The threshold in nilfs_cleanerd_select_segments() can no longer be set
to sustat->ss_nongc_ctime on default, because the greedy/cost-benefit
policies do not return a timestamp, so their importance values cannot b=
e
compared to each other. Instead segments that are younger than
sustat->ss_nongc_ctime are always excluded.

[1] Mendel Rosenblum and John K. Ousterhout. The design and implementa-
tion of a log-structured file system. ACM Trans. Comput. Syst.,
10(1):26=E2=80=9352, February 1992.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 sbin/cleanerd/cldconfig.c | 79 +++++++++++++++++++++++++++++++++++++++=
++++++--
 sbin/cleanerd/cldconfig.h | 22 +++++++++----
 sbin/cleanerd/cleanerd.c  | 43 ++++++++++++++++++++------
 3 files changed, 126 insertions(+), 18 deletions(-)

diff --git a/sbin/cleanerd/cldconfig.c b/sbin/cleanerd/cldconfig.c
index c8b197b..68090e9 100644
--- a/sbin/cleanerd/cldconfig.c
+++ b/sbin/cleanerd/cldconfig.c
@@ -380,7 +380,9 @@ nilfs_cldconfig_handle_clean_check_interval(struct =
nilfs_cldconfig *config,
 }
=20
 static unsigned long long
-nilfs_cldconfig_selection_policy_timestamp(const struct nilfs_suinfo *=
si)
+nilfs_cldconfig_selection_policy_timestamp(const struct nilfs_suinfo *=
si,
+					   const struct nilfs_sustat *sustat,
+					   __u64 prottime)
 {
 	return si->sui_lastmod;
 }
@@ -392,13 +394,84 @@ nilfs_cldconfig_handle_selection_policy_timestamp=
(struct nilfs_cldconfig *config
 	config->cf_selection_policy.p_importance =3D
 		NILFS_CLDCONFIG_SELECTION_POLICY_IMPORTANCE;
 	config->cf_selection_policy.p_threshold =3D
-		NILFS_CLDCONFIG_SELECTION_POLICY_THRESHOLD;
+		NILFS_CLDCONFIG_SELECTION_POLICY_NO_THRESHOLD;
+	config->cf_selection_policy.p_comparison =3D
+		NILFS_CLDCONFIG_SELECTION_POLICY_SMALLER_IS_BETTER;
+	return 0;
+}
+
+static unsigned long long
+nilfs_cldconfig_selection_policy_greedy(const struct nilfs_suinfo *si,
+					const struct nilfs_sustat *sustat,
+					__u64 prottime)
+{
+	if (si->sui_nblocks < si->sui_nlive_blks ||
+	    si->sui_nlive_lastmod >=3D prottime)
+		return 0;
+
+	return si->sui_nblocks - si->sui_nlive_blks;
+}
+
+static int
+nilfs_cldconfig_handle_selection_policy_greedy(struct nilfs_cldconfig =
*config,
+					       char **tokens, size_t ntoks)
+{
+	config->cf_selection_policy.p_importance =3D
+		nilfs_cldconfig_selection_policy_greedy;
+	config->cf_selection_policy.p_threshold =3D
+		NILFS_CLDCONFIG_SELECTION_POLICY_NO_THRESHOLD;
+	config->cf_selection_policy.p_comparison =3D
+		NILFS_CLDCONFIG_SELECTION_POLICY_BIGGER_IS_BETTER;
+	return 0;
+}
+
+static unsigned long long
+nilfs_cldconfig_selection_policy_cost_benefit(const struct nilfs_suinf=
o *si,
+					      const struct nilfs_sustat *sustat,
+					      __u64 prottime)
+{
+	__u32 free_blocks, cleaning_cost;
+	unsigned long long age;
+
+	if (si->sui_nblocks < si->sui_nlive_blks ||
+	    sustat->ss_nongc_ctime < si->sui_lastmod ||
+	    si->sui_nlive_lastmod >=3D prottime)
+		return 0;
+
+	free_blocks =3D si->sui_nblocks - si->sui_nlive_blks;
+	/* read the whole segment + write the live blocks */
+	cleaning_cost =3D 2 * si->sui_nlive_blks;
+	/*
+	 * multiply by 1000 to convert age to milliseconds
+	 * (higher precision for division)
+	 */
+	age =3D (sustat->ss_nongc_ctime - si->sui_lastmod) * 1000;
+
+	if (cleaning_cost =3D=3D 0)
+		cleaning_cost =3D 1;
+
+	return (age * free_blocks) / cleaning_cost;
+}
+
+static int
+nilfs_cldconfig_handle_selection_policy_cost_benefit(
+						struct nilfs_cldconfig *config,
+						char **tokens, size_t ntoks)
+{
+	config->cf_selection_policy.p_importance =3D
+		nilfs_cldconfig_selection_policy_cost_benefit;
+	config->cf_selection_policy.p_threshold =3D
+		NILFS_CLDCONFIG_SELECTION_POLICY_NO_THRESHOLD;
+	config->cf_selection_policy.p_comparison =3D
+		NILFS_CLDCONFIG_SELECTION_POLICY_BIGGER_IS_BETTER;
 	return 0;
 }
=20
 static const struct nilfs_cldconfig_polhandle
 nilfs_cldconfig_polhandle_table[] =3D {
 	{"timestamp",	nilfs_cldconfig_handle_selection_policy_timestamp},
+	{"greedy",	nilfs_cldconfig_handle_selection_policy_greedy},
+	{"cost-benefit", nilfs_cldconfig_handle_selection_policy_cost_benefit=
},
 };
=20
 #define NILFS_CLDCONFIG_NPOLHANDLES			\
@@ -690,6 +763,8 @@ static void nilfs_cldconfig_set_default(struct nilf=
s_cldconfig *config,
 		NILFS_CLDCONFIG_SELECTION_POLICY_IMPORTANCE;
 	config->cf_selection_policy.p_threshold =3D
 		NILFS_CLDCONFIG_SELECTION_POLICY_THRESHOLD;
+	config->cf_selection_policy.p_comparison =3D
+		NILFS_CLDCONFIG_SELECTION_POLICY_COMPARISON;
 	config->cf_protection_period.tv_sec =3D NILFS_CLDCONFIG_PROTECTION_PE=
RIOD;
 	config->cf_protection_period.tv_usec =3D 0;
=20
diff --git a/sbin/cleanerd/cldconfig.h b/sbin/cleanerd/cldconfig.h
index 2a0af5f..3c9f5e6 100644
--- a/sbin/cleanerd/cldconfig.h
+++ b/sbin/cleanerd/cldconfig.h
@@ -30,16 +30,22 @@
 #include <sys/time.h>
 #include <syslog.h>
=20
+struct nilfs;
+struct nilfs_sustat;
 struct nilfs_suinfo;
=20
 /**
  * struct nilfs_selection_policy -
- * @p_importance:
- * @p_threshold:
+ * @p_importance: function to calculate the importance for the policy
+ * @p_threshold: segments with lower/higher importance are ignored
+ * @p_comparison: flag that indicates how to sort the importance
  */
 struct nilfs_selection_policy {
-	unsigned long long (*p_importance)(const struct nilfs_suinfo *);
+	unsigned long long (*p_importance)(const struct nilfs_suinfo *,
+					   const struct nilfs_sustat *,
+					   __u64);
 	unsigned long long p_threshold;
+	int p_comparison;
 };
=20
 /**
@@ -111,9 +117,15 @@ struct nilfs_cldconfig {
 	unsigned long cf_mc_min_reclaimable_blocks;
 };
=20
+#define NILFS_CLDCONFIG_SELECTION_POLICY_SMALLER_IS_BETTER	0
+#define NILFS_CLDCONFIG_SELECTION_POLICY_BIGGER_IS_BETTER	1
+#define NILFS_CLDCONFIG_SELECTION_POLICY_NO_THRESHOLD	0
 #define NILFS_CLDCONFIG_SELECTION_POLICY_IMPORTANCE	\
 			nilfs_cldconfig_selection_policy_timestamp
-#define NILFS_CLDCONFIG_SELECTION_POLICY_THRESHOLD	0
+#define NILFS_CLDCONFIG_SELECTION_POLICY_THRESHOLD	\
+			NILFS_CLDCONFIG_SELECTION_POLICY_NO_THRESHOLD
+#define NILFS_CLDCONFIG_SELECTION_POLICY_COMPARISON	\
+			NILFS_CLDCONFIG_SELECTION_POLICY_SMALLER_IS_BETTER
 #define NILFS_CLDCONFIG_PROTECTION_PERIOD		3600
 #define NILFS_CLDCONFIG_MIN_CLEAN_SEGMENTS		10
 #define NILFS_CLDCONFIG_MIN_CLEAN_SEGMENTS_UNIT		NILFS_SIZE_UNIT_PERCE=
NT
@@ -135,8 +147,6 @@ struct nilfs_cldconfig {
=20
 #define NILFS_CLDCONFIG_NSEGMENTS_PER_CLEAN_MAX	32
=20
-struct nilfs;
-
 int nilfs_cldconfig_read(struct nilfs_cldconfig *config, const char *p=
ath,
 			 struct nilfs *nilfs);
=20
diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index d37bd5c..e0741f1 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -417,7 +417,7 @@ static void nilfs_cleanerd_destroy(struct nilfs_cle=
anerd *cleanerd)
 	free(cleanerd);
 }
=20
-static int nilfs_comp_segimp(const void *elem1, const void *elem2)
+static int nilfs_comp_segimp_asc(const void *elem1, const void *elem2)
 {
 	const struct nilfs_segimp *segimp1 =3D elem1, *segimp2 =3D elem2;
=20
@@ -429,6 +429,18 @@ static int nilfs_comp_segimp(const void *elem1, co=
nst void *elem2)
 	return (segimp1->si_segnum < segimp2->si_segnum) ? -1 : 1;
 }
=20
+static int nilfs_comp_segimp_desc(const void *elem1, const void *elem2=
)
+{
+	const struct nilfs_segimp *segimp1 =3D elem1, *segimp2 =3D elem2;
+
+	if (segimp1->si_importance > segimp2->si_importance)
+		return -1;
+	else if (segimp1->si_importance < segimp2->si_importance)
+		return 1;
+
+	return (segimp1->si_segnum < segimp2->si_segnum) ? -1 : 1;
+}
+
 static int nilfs_cleanerd_automatic_suspend(struct nilfs_cleanerd *cle=
anerd)
 {
 	return cleanerd->config.cf_min_clean_segments > 0;
@@ -580,7 +592,7 @@ nilfs_cleanerd_select_segments(struct nilfs_cleaner=
d *cleanerd,
 	size_t count, nsegs;
 	ssize_t nssegs, n;
 	unsigned long long imp, thr;
-	int i;
+	int i, sib;
=20
 	nsegs =3D nilfs_cleanerd_ncleansegs(cleanerd);
 	nilfs =3D cleanerd->nilfs;
@@ -600,11 +612,17 @@ nilfs_cleanerd_select_segments(struct nilfs_clean=
erd *cleanerd,
 	prottime =3D tv2.tv_sec;
 	oldest =3D tv.tv_sec;
=20
-	/* The segments that have larger importance than thr are not
+	/*
+	 * sufile extension fields may not be initialized by
+	 * nilfs_get_suinfo()
+	 */
+	memset(si, 0, sizeof(si));
+
+	/* The segments that have larger/smaller importance than thr are not
 	 * selected. */
-	thr =3D (config->cf_selection_policy.p_threshold !=3D 0) ?
-		config->cf_selection_policy.p_threshold :
-		sustat->ss_nongc_ctime;
+	thr =3D config->cf_selection_policy.p_threshold;
+	sib =3D config->cf_selection_policy.p_comparison =3D=3D
+			NILFS_CLDCONFIG_SELECTION_POLICY_SMALLER_IS_BETTER;
=20
 	for (segnum =3D 0; segnum < sustat->ss_nsegs; segnum +=3D n) {
 		count =3D min_t(__u64, sustat->ss_nsegs - segnum,
@@ -615,11 +633,13 @@ nilfs_cleanerd_select_segments(struct nilfs_clean=
erd *cleanerd,
 			goto out;
 		}
 		for (i =3D 0; i < n; i++) {
-			if (!nilfs_suinfo_reclaimable(&si[i]))
+			if (!nilfs_suinfo_reclaimable(&si[i]) ||
+				si[i].sui_lastmod >=3D sustat->ss_nongc_ctime)
 				continue;
=20
-			imp =3D config->cf_selection_policy.p_importance(&si[i]);
-			if (imp < thr) {
+			imp =3D config->cf_selection_policy.p_importance(&si[i],
+					sustat, prottime);
+			if (!thr || (sib && imp < thr) || (!sib && imp > thr)) {
 				if (si[i].sui_lastmod < oldest)
 					oldest =3D si[i].sui_lastmod;
 				if (si[i].sui_lastmod < prottime) {
@@ -642,7 +662,10 @@ nilfs_cleanerd_select_segments(struct nilfs_cleane=
rd *cleanerd,
 			break;
 		}
 	}
-	nilfs_vector_sort(smv, nilfs_comp_segimp);
+	if (sib)
+		nilfs_vector_sort(smv, nilfs_comp_segimp_asc);
+	else
+		nilfs_vector_sort(smv, nilfs_comp_segimp_desc);
=20
 	nssegs =3D (nilfs_vector_get_size(smv) < nsegs) ?
 		nilfs_vector_get_size(smv) : nsegs;
--=20
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
