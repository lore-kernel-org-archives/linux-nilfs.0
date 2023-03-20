From: Yangtao Li via Linux-f2fs-devel <linux-f2fs-devel@lists.sourceforge.net>
Subject: [RESEND,
 PATCH v2 01/10] kobject: introduce kobject_del_and_put()
Date: Tue, 21 Mar 2023 02:46:56 +0800
Message-ID: <20230320184657.56198-1-frank.li@vivo.com>
Reply-To: Yangtao Li <frank.li@vivo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=MIME-Version:Content-Type:Content-Transfer-Encoding
 :Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=2f6n1UCEAAcz+QTfKGhjodobaG8npGp7MDh8Bm+DuiM=; b=YHzXxDARGFJn8aZG5sWkq23r5D
 N9R0sJ7bZS3/2lmb4W9js8AuKXx4Sea+7X4Vq9eq90ohatFyNBZaXicNLLx60TNflLXsDc3jzOJyt
 Zeu7+sF8IgH4vaxJ+U2cYTMMWIAXRzfH8epSmrCLDH1FeMz1giwwmkoWIOsbK4naxJhs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Date:
 Subject:Cc:To:From:Sender:Reply-To:Content-ID:Content-Description:Resent-Date
 :Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:
 References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
 List-Owner:List-Archive; bh=2f6n1UCEAAcz+QTfKGhjodobaG8npGp7MDh8Bm+DuiM=; b=V
 cOz/o8odZKCe4Co5cw1yukICcp9F3GNvR5vSrXXQpNQaA08+Qpqqb9JlhayyGVSXxWPrJLvV22hzE
 22fdYcfmFBqbIuyMQWGl7+nStYrIjSDVY/r+wX4TWsyyi32c6bpk8MQpD/2bNdc50XAoDwth0rlC5
 RzUBdKOp6JcCSH5s=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2; 
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2f6n1UCEAAcz+QTfKGhjodobaG8npGp7MDh8Bm+DuiM=;
 b=avahy9j67MbUgEV5UHkvAGGIawSEz4La41fbV8o1DV1X8t1tKXHX+WCCRf1CyV/VRvVL8ZALS7+2R+5KWC8MzPVQfyoobHz9Znm8DOjKgbBv7pRzOVt35BycfRATHt43DUXPW3+802qVMMPweVVPpJzuC/pWKzMjSWCD9mrgpRL9Bu/wn8CDDB23RS13T2fH39QxZP+PE9sM+zzpAOMWnJr/GUs7PpOjG2OP+Kk6pJ2aAeZFPTmXaysjGvXv2oge77GXCWoMNGiwUKxPYkhRjCV4k/9hZDd6pKM/J+rjATqQ1HAYwmBHiTLWU/STr6IgEAYoRXp5Tnb38Y/Sg4eeuw==
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: clm@fb.com, josef@toxicpanda.com, dsterba@suse.com, xiang@kernel.org, chao@kernel.org, huyue2@coolpad.com, jefflexu@linux.alibaba.com, jaegeuk@kernel.org, trond.myklebust@hammerspace.com, anna@kernel.org, konishi.ryusuke@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, richard@nod.at, djwong@kernel.org, damien.lemoal@opensource.wdc.com, naohiro.aota@wdc.com, jth@kernel.org, gregkh@linuxfoundation.org, rafael@kernel.org
Cc: linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, Yangtao Li <frank.li@vivo.com>, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org

There are plenty of using kobject_del() and kobject_put() together
in the kernel tree. This patch wraps these two calls in a single helper.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
---
v2:
-add kobject_del_and_put() users
resend patchset to gregkh, Rafael and Damien
 include/linux/kobject.h |  1 +
 lib/kobject.c           | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index bdab370a24f4..782d4bd119f8 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -111,6 +111,7 @@ extern struct kobject *kobject_get(struct kobject *kobj);
 extern struct kobject * __must_check kobject_get_unless_zero(
 						struct kobject *kobj);
 extern void kobject_put(struct kobject *kobj);
+extern void kobject_del_and_put(struct kobject *kobj);
 
 extern const void *kobject_namespace(const struct kobject *kobj);
 extern void kobject_get_ownership(const struct kobject *kobj,
diff --git a/lib/kobject.c b/lib/kobject.c
index 6e2f0bee3560..8c0293e37214 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -731,6 +731,20 @@ void kobject_put(struct kobject *kobj)
 }
 EXPORT_SYMBOL(kobject_put);
 
+/**
+ * kobject_del_and_put() - Delete kobject.
+ * @kobj: object.
+ *
+ * Unlink kobject from hierarchy and decrement the refcount.
+ * If refcount is 0, call kobject_cleanup().
+ */
+void kobject_del_and_put(struct kobject *kobj)
+{
+	kobject_del(kobj);
+	kobject_put(kobj);
+}
+EXPORT_SYMBOL_GPL(kobject_del_and_put);
+
 static void dynamic_kobj_release(struct kobject *kobj)
 {
 	pr_debug("kobject: (%p): %s\n", kobj, __func__);
@@ -874,8 +888,7 @@ void kset_unregister(struct kset *k)
 {
 	if (!k)
 		return;
-	kobject_del(&k->kobj);
-	kobject_put(&k->kobj);
+	kobject_del_and_put(&k->kobj);
 }
 EXPORT_SYMBOL(kset_unregister);
 
-- 
2.35.1
