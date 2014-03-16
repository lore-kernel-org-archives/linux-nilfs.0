From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 2/4] nilfs-utils: add cost-benefit and greedy policies
Date: Sun, 16 Mar 2014 16:50:53 +0100
Message-ID: <5325C85D.7040900@gmx.net>
References: <36b7f57861b69c7fdb9d9e54a21df6f5c7f21061.1394966935.git.andreas.rohner@gmx.net>	<36b7f57861b69c7fdb9d9e54a21df6f5c7f21061.1394966935.git.andreas.rohner@gmx.net>	<cc43be2e6bba5367fd2982dc0df5255b884bdace.1394966935.git.andreas.rohner@gmx.net> <20140316.215545.291456562.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140316.215545.291456562.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-03-16 13:55, Ryusuke Konishi wrote:
> On Sun, 16 Mar 2014 11:49:16 +0100, Andreas Rohner wrote:
>> This patch implements the cost-benefit and greedy GC policies. These=
 are
>> well known policies for log-structured file systems [1].
>>
>> * Greedy:
>>   Select the segments with the most free space.
>> * Cost-Benefit:
>>   Perform a cost-benefit analysis, whereby the free space gained is
>>   weighed against the cost of collecting the segment.
>>
>> Since especially cost-benefit needed more information than was avail=
able
>> in nilfs_suinfo, a few extra parameters were added to the policy
>> callback function prototype. The policy threshold was removed, since=
 it
>> served no real purpose. The flag p_comparison was added to indicate =
how
>> the importance values should be interpreted. For example for the
>> timestamp policy smaller values mean older timestamps, which is bett=
er.
>> For greedy and cost-benefit on the other hand higher values are bett=
er.
>> nilfs_cleanerd_select_segments() was updated accordingly.
>>
>> [1] Mendel Rosenblum and John K. Ousterhout. The design and implemen=
ta-
>> tion of a log-structured file system. ACM Trans. Comput. Syst.,
>> 10(1):26=E2=80=9352, February 1992.
>>
>> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
>> ---
>>  include/nilfs2_fs.h       |   9 ++++-
>>  sbin/cleanerd/cldconfig.c | 100 +++++++++++++++++++++++++++++++++++=
++++++++---
>>  sbin/cleanerd/cldconfig.h |  18 +++++----
>>  sbin/cleanerd/cleanerd.c  |  56 ++++++++++++++++----------
>>  4 files changed, 149 insertions(+), 34 deletions(-)
>>
>> diff --git a/include/nilfs2_fs.h b/include/nilfs2_fs.h
>> index a16ad4c..967c2af 100644
>> --- a/include/nilfs2_fs.h
>> +++ b/include/nilfs2_fs.h
>> @@ -483,7 +483,7 @@ struct nilfs_dat_entry {
>>  	__le64 de_blocknr;
>>  	__le64 de_start;
>>  	__le64 de_end;
>> -	__le64 de_rsv;
>> +	__le64 de_ss;
>>  };
>> =20
>>  /**
>> @@ -612,11 +612,13 @@ struct nilfs_cpfile_header {
>>   * @su_lastmod: last modified timestamp
>>   * @su_nblocks: number of blocks in segment
>>   * @su_flags: flags
>> + * @su_lastdec: last decrement of su_nblocks timestamp
>>   */
>>  struct nilfs_segment_usage {
>>  	__le64 su_lastmod;
>>  	__le32 su_nblocks;
>>  	__le32 su_flags;
>> +	__le64 su_lastdec;
>>  };
>> =20
>>  /* segment usage flag */
>> @@ -659,6 +661,7 @@ nilfs_segment_usage_set_clean(struct nilfs_segme=
nt_usage *su)
>>  	su->su_lastmod =3D cpu_to_le64(0);
>>  	su->su_nblocks =3D cpu_to_le32(0);
>>  	su->su_flags =3D cpu_to_le32(0);
>> +	su->su_lastdec =3D cpu_to_le64(0);
>>  }
>> =20
>>  static inline int
>> @@ -690,11 +693,13 @@ struct nilfs_sufile_header {
>>   * @sui_lastmod: timestamp of last modification
>>   * @sui_nblocks: number of written blocks in segment
>>   * @sui_flags: segment usage flags
>> + * @sui_lastdec: last decrement of sui_nblocks timestamp
>>   */
>>  struct nilfs_suinfo {
>>  	__u64 sui_lastmod;
>>  	__u32 sui_nblocks;
>>  	__u32 sui_flags;
>> +	__u64 sui_lastdec;
>>  };
>> =20
>>  #define NILFS_SUINFO_FNS(flag, name)					\
>> @@ -732,6 +737,7 @@ enum {
>>  	NILFS_SUINFO_UPDATE_LASTMOD,
>>  	NILFS_SUINFO_UPDATE_NBLOCKS,
>>  	NILFS_SUINFO_UPDATE_FLAGS,
>> +	NILFS_SUINFO_UPDATE_LASTDEC,
>>  	__NR_NILFS_SUINFO_UPDATE_FIELDS,
>>  };
>> =20
>> @@ -755,6 +761,7 @@ nilfs_suinfo_update_##name(const struct nilfs_su=
info_update *sup)	\
>>  NILFS_SUINFO_UPDATE_FNS(LASTMOD, lastmod)
>>  NILFS_SUINFO_UPDATE_FNS(NBLOCKS, nblocks)
>>  NILFS_SUINFO_UPDATE_FNS(FLAGS, flags)
>> +NILFS_SUINFO_UPDATE_FNS(LASTDEC, lastdec)
>> =20
>>  enum {
>>  	NILFS_CHECKPOINT,
>> diff --git a/sbin/cleanerd/cldconfig.c b/sbin/cleanerd/cldconfig.c
>> index c8b197b..ade974a 100644
>> --- a/sbin/cleanerd/cldconfig.c
>> +++ b/sbin/cleanerd/cldconfig.c
>> @@ -380,7 +380,10 @@ nilfs_cldconfig_handle_clean_check_interval(str=
uct nilfs_cldconfig *config,
>>  }
>> =20
>>  static unsigned long long
>> -nilfs_cldconfig_selection_policy_timestamp(const struct nilfs_suinf=
o *si)
>> +nilfs_cldconfig_selection_policy_timestamp(struct nilfs *nilfs,
>> +					   const struct nilfs_sustat *sustat,
>> +					   const struct nilfs_suinfo *si,
>> +					   __u64 prottime)
>>  {
>>  	return si->sui_lastmod;
>>  }
>> @@ -391,14 +394,101 @@ nilfs_cldconfig_handle_selection_policy_times=
tamp(struct nilfs_cldconfig *config
>>  {
>>  	config->cf_selection_policy.p_importance =3D
>>  		NILFS_CLDCONFIG_SELECTION_POLICY_IMPORTANCE;
>> -	config->cf_selection_policy.p_threshold =3D
>> -		NILFS_CLDCONFIG_SELECTION_POLICY_THRESHOLD;
>> +	config->cf_selection_policy.p_comparison =3D
>> +			NILFS_CLDCONFIG_SELECTION_POLICY_SMALLER_IS_BETTER;
>> +	return 0;
>> +}
>> +
>> +static unsigned long long
>> +nilfs_cldconfig_selection_policy_greedy(struct nilfs *nilfs,
>> +				        const struct nilfs_sustat *sustat,
>> +				        const struct nilfs_suinfo *si,
>> +				        __u64 prottime)
>> +{
>> +	__u32 value, max_blocks =3D nilfs_get_blocks_per_segment(nilfs);
>> +
>> +	if (max_blocks < si->sui_nblocks)
>> +		return 0;
>> +
>> +	value =3D max_blocks - si->sui_nblocks;
>> +
>> +	/*
>> +	 * the value of sui_nblocks is probably not accurate
>> +	 * because blocks inside the protection period are not
>> +	 * considered to be dead
>> +	 */
>> +	if (si->sui_lastdec >=3D prottime)
>> +		value >>=3D 4;
>> +
>> +	return value;
>> +}
>> +
>> +static int
>> +nilfs_cldconfig_handle_selection_policy_greedy(struct nilfs_cldconf=
ig *config,
>> +					       char **tokens, size_t ntoks)
>> +{
>> +	config->cf_selection_policy.p_importance =3D
>> +			nilfs_cldconfig_selection_policy_greedy;
>> +	config->cf_selection_policy.p_comparison =3D
>> +			NILFS_CLDCONFIG_SELECTION_POLICY_BIGGER_IS_BETTER;
>> +	return 0;
>> +}
>> +
>> +static unsigned long long
>> +nilfs_cldconfig_selection_policy_cost_benefit(struct nilfs *nilfs,
>> +					      const struct nilfs_sustat *sustat,
>> +					      const struct nilfs_suinfo *si,
>> +					      __u64 prottime)
>> +{
>> +	__u32 free_blocks, cleaning_cost;
>> +	unsigned long long value, age;
>> +
>> +	free_blocks =3D nilfs_get_blocks_per_segment(nilfs) - si->sui_nblo=
cks;
>> +	/* read the whole segment + write the live blocks */
>> +	cleaning_cost =3D 2 * si->sui_nblocks;
>> +	/*
>> +	 * multiply by 1000 to convert age to milliseconds
>> +	 * (higher precision for division)
>> +	 */
>> +	age =3D (sustat->ss_nongc_ctime - si->sui_lastmod) * 1000;
>> +
>> +	if (sustat->ss_nongc_ctime < si->sui_lastmod)
>> +		return 0;
>> +
>> +	if (cleaning_cost =3D=3D 0)
>> +		cleaning_cost =3D 1;
>> +
>> +
>> +	value =3D (age * free_blocks) / cleaning_cost;
>> +
>> +	/*
>> +	 * the value of sui_nblocks is probably not accurate
>> +	 * because blocks inside the protection period are not
>> +	 * considered to be dead
>> +	 */
>> +	if (si->sui_lastdec >=3D prottime)
>> +		value >>=3D 4;
>> +
>> +	return value;
>> +}
>> +
>> +static int
>> +nilfs_cldconfig_handle_selection_policy_cost_benefit(
>> +						struct nilfs_cldconfig *config,
>> +						char **tokens, size_t ntoks)
>> +{
>> +	config->cf_selection_policy.p_importance =3D
>> +			nilfs_cldconfig_selection_policy_cost_benefit;
>> +	config->cf_selection_policy.p_comparison =3D
>> +			NILFS_CLDCONFIG_SELECTION_POLICY_BIGGER_IS_BETTER;
>>  	return 0;
>>  }
>> =20
>>  static const struct nilfs_cldconfig_polhandle
>>  nilfs_cldconfig_polhandle_table[] =3D {
>>  	{"timestamp",	nilfs_cldconfig_handle_selection_policy_timestamp},
>> +	{"greedy",	nilfs_cldconfig_handle_selection_policy_greedy},
>> +	{"cost-benefit", nilfs_cldconfig_handle_selection_policy_cost_bene=
fit},
>>  };
>> =20
>>  #define NILFS_CLDCONFIG_NPOLHANDLES			\
>> @@ -688,8 +778,8 @@ static void nilfs_cldconfig_set_default(struct n=
ilfs_cldconfig *config,
>> =20
>>  	config->cf_selection_policy.p_importance =3D
>>  		NILFS_CLDCONFIG_SELECTION_POLICY_IMPORTANCE;
>> -	config->cf_selection_policy.p_threshold =3D
>> -		NILFS_CLDCONFIG_SELECTION_POLICY_THRESHOLD;
>> +	config->cf_selection_policy.p_comparison =3D
>> +		NILFS_CLDCONFIG_SELECTION_POLICY_SMALLER_IS_BETTER;
>>  	config->cf_protection_period.tv_sec =3D NILFS_CLDCONFIG_PROTECTION=
_PERIOD;
>>  	config->cf_protection_period.tv_usec =3D 0;
>> =20
>> diff --git a/sbin/cleanerd/cldconfig.h b/sbin/cleanerd/cldconfig.h
>> index 0a598d5..95d2fde 100644
>> --- a/sbin/cleanerd/cldconfig.h
>> +++ b/sbin/cleanerd/cldconfig.h
>> @@ -30,16 +30,21 @@
>>  #include <sys/time.h>
>>  #include <syslog.h>
>> =20
>> +struct nilfs;
>> +struct nilfs_sustat;
>>  struct nilfs_suinfo;
>> =20
>>  /**
>>   * struct nilfs_selection_policy -
>> - * @p_importance:
>> - * @p_threshold:
>> + * @p_importance: function to calculate the importance for the poli=
cy
>> + * @p_comparison: flag that indicates how to sort the importance
>>   */
>>  struct nilfs_selection_policy {
>> -	unsigned long long (*p_importance)(const struct nilfs_suinfo *);
>> -	unsigned long long p_threshold;
>> +	unsigned long long (*p_importance)(struct nilfs *nilfs,
>> +					   const struct nilfs_sustat *sustat,
>> +					   const struct nilfs_suinfo *,
>> +					   __u64 prottime);
>> +	int p_comparison;
>>  };
>> =20
>>  /**
>> @@ -113,7 +118,8 @@ struct nilfs_cldconfig {
>> =20
>>  #define NILFS_CLDCONFIG_SELECTION_POLICY_IMPORTANCE	\
>>  			nilfs_cldconfig_selection_policy_timestamp
>> -#define NILFS_CLDCONFIG_SELECTION_POLICY_THRESHOLD	0
>> +#define NILFS_CLDCONFIG_SELECTION_POLICY_BIGGER_IS_BETTER	0
>> +#define NILFS_CLDCONFIG_SELECTION_POLICY_SMALLER_IS_BETTER	1
>>  #define NILFS_CLDCONFIG_PROTECTION_PERIOD		3600
>>  #define NILFS_CLDCONFIG_MIN_CLEAN_SEGMENTS		10
>>  #define NILFS_CLDCONFIG_MIN_CLEAN_SEGMENTS_UNIT		NILFS_SIZE_UNIT_PE=
RCENT
>> @@ -135,8 +141,6 @@ struct nilfs_cldconfig {
>> =20
>>  #define NILFS_CLDCONFIG_NSEGMENTS_PER_CLEAN_MAX	32
>> =20
>> -struct nilfs;
>> -
>>  int nilfs_cldconfig_read(struct nilfs_cldconfig *config, const char=
 *path,
>>  			 struct nilfs *nilfs);
>> =20
>> diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
>> index 17de87b..8df3a07 100644
>> --- a/sbin/cleanerd/cleanerd.c
>> +++ b/sbin/cleanerd/cleanerd.c
>> @@ -417,7 +417,7 @@ static void nilfs_cleanerd_destroy(struct nilfs_=
cleanerd *cleanerd)
>>  	free(cleanerd);
>>  }
>> =20
>> -static int nilfs_comp_segimp(const void *elem1, const void *elem2)
>> +static int nilfs_comp_segimp_asc(const void *elem1, const void *ele=
m2)
>>  {
>>  	const struct nilfs_segimp *segimp1 =3D elem1, *segimp2 =3D elem2;
>> =20
>> @@ -429,6 +429,18 @@ static int nilfs_comp_segimp(const void *elem1,=
 const void *elem2)
>>  	return (segimp1->si_segnum < segimp2->si_segnum) ? -1 : 1;
>>  }
>> =20
>> +static int nilfs_comp_segimp_desc(const void *elem1, const void *el=
em2)
>> +{
>> +	const struct nilfs_segimp *segimp1 =3D elem1, *segimp2 =3D elem2;
>> +
>> +	if (segimp1->si_importance > segimp2->si_importance)
>> +		return -1;
>> +	else if (segimp1->si_importance < segimp2->si_importance)
>> +		return 1;
>> +
>> +	return (segimp1->si_segnum < segimp2->si_segnum) ? -1 : 1;
>> +}
>> +
>>  static int nilfs_cleanerd_automatic_suspend(struct nilfs_cleanerd *=
cleanerd)
>>  {
>>  	return cleanerd->config.cf_min_clean_segments > 0;
>> @@ -579,7 +591,7 @@ nilfs_cleanerd_select_segments(struct nilfs_clea=
nerd *cleanerd,
>>  	__u64 segnum;
>>  	size_t count, nsegs;
>>  	ssize_t nssegs, n;
>> -	unsigned long long imp, thr;
>> +	unsigned long long imp;
>>  	int i;
>> =20
>>  	nsegs =3D nilfs_cleanerd_ncleansegs(cleanerd);
>> @@ -600,11 +612,8 @@ nilfs_cleanerd_select_segments(struct nilfs_cle=
anerd *cleanerd,
>>  	prottime =3D tv2.tv_sec;
>>  	oldest =3D tv.tv_sec;
>> =20
>> -	/* The segments that have larger importance than thr are not
>> -	 * selected. */
>> -	thr =3D (config->cf_selection_policy.p_threshold !=3D 0) ?
>> -		config->cf_selection_policy.p_threshold :
>> -		sustat->ss_nongc_ctime;
>> +	/* sui_lastdec may not be set by nilfs_get_suinfo */
>> +	memset(si, 0, sizeof(si));
>> =20
>>  	for (segnum =3D 0; segnum < sustat->ss_nsegs; segnum +=3D n) {
>>  		count =3D min_t(__u64, sustat->ss_nsegs - segnum,
>> @@ -615,22 +624,23 @@ nilfs_cleanerd_select_segments(struct nilfs_cl=
eanerd *cleanerd,
>>  			goto out;
>>  		}
>>  		for (i =3D 0; i < n; i++) {
>> -			if (!nilfs_suinfo_reclaimable(&si[i]))
>> +			if (!nilfs_suinfo_reclaimable(&si[i]) ||
>> +				si[i].sui_lastmod >=3D sustat->ss_nongc_ctime)
>>  				continue;
>> =20
>> -			imp =3D config->cf_selection_policy.p_importance(&si[i]);
>> -			if (imp < thr) {
>> -				if (si[i].sui_lastmod < oldest)
>> -					oldest =3D si[i].sui_lastmod;
>> -				if (si[i].sui_lastmod < prottime) {
>> -					sm =3D nilfs_vector_get_new_element(smv);
>> -					if (sm =3D=3D NULL) {
>> -						nssegs =3D -1;
>> -						goto out;
>> -					}
>> -					sm->si_segnum =3D segnum + i;
>> -					sm->si_importance =3D imp;
>> +			imp =3D config->cf_selection_policy.p_importance(nilfs,
>> +					sustat, &si[i], prottime);
>> +
>> +			if (si[i].sui_lastmod < oldest)
>> +				oldest =3D si[i].sui_lastmod;
>> +			if (si[i].sui_lastmod < prottime) {
>> +				sm =3D nilfs_vector_get_new_element(smv);
>> +				if (sm =3D=3D NULL) {
>> +					nssegs =3D -1;
>> +					goto out;
>>  				}
>> +				sm->si_segnum =3D segnum + i;
>> +				sm->si_importance =3D imp;
>>  			}
>>  		}
>>  		if (n =3D=3D 0) {
>> @@ -642,7 +652,11 @@ nilfs_cleanerd_select_segments(struct nilfs_cle=
anerd *cleanerd,
>>  			break;
>>  		}
>>  	}
>> -	nilfs_vector_sort(smv, nilfs_comp_segimp);
>> +	if (config->cf_selection_policy.p_comparison =3D=3D
>> +			NILFS_CLDCONFIG_SELECTION_POLICY_SMALLER_IS_BETTER)
>> +		nilfs_vector_sort(smv, nilfs_comp_segimp_asc);
>> +	else
>> +		nilfs_vector_sort(smv, nilfs_comp_segimp_desc);
>> =20
>>  	nssegs =3D (nilfs_vector_get_size(smv) < nsegs) ?
>>  		nilfs_vector_get_size(smv) : nsegs;
>> --=20
>> 1.9.0
>=20
> scripts/checkpatch.pl detected the following coding style issues:
>=20
> ERROR: code indent should use tabs where possible
> #171: FILE: sbin/cleanerd/cldconfig.c:404:
> +^I^I^I^I        const struct nilfs_sustat *sustat,$
>=20
> ERROR: code indent should use tabs where possible
> #172: FILE: sbin/cleanerd/cldconfig.c:405:
> +^I^I^I^I        const struct nilfs_suinfo *si,$
>=20
> ERROR: code indent should use tabs where possible
> #173: FILE: sbin/cleanerd/cldconfig.c:406:
> +^I^I^I^I        __u64 prottime)$
>=20
>=20
> Please mind it next time. (You don't have to resubmit the whole serie=
s
> now for this).

Normally I execute checkpatch.pl automatically via the pre-commit hook.
=46or some reason the pre-commit hook got overwritten in my local repo.=
 I
am sorry for that.

> I would like to first understand this series, but I am very busy
> recently.  (Also, I am still pending review of Vycheslav's xattr
> patchset.)  So, let me go forward a little bit at a time.

Ok no problem.

Regards,
Andreas Rohner

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
