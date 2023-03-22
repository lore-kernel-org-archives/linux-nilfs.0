From: Yangtao Li via Linux-f2fs-devel <linux-f2fs-devel@lists.sourceforge.net>
Subject: [PATCH v3 01/10] kobject: introduce kobject_del_and_put()
Date: Thu, 23 Mar 2023 00:58:30 +0800
Message-ID: <20230322165830.55071-1-frank.li@vivo.com>
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
 bh=JWU/bvQplpq32Knxv8Pox9YEw/v27hnBYemurc1ELJ8=; b=ma6ZYjP2iS6TpRn9pCwzDgCSHx
 ZV9gcDHIMy6cACnx7BUbMcWBV1sx6iKjshHKWyU31DnSZv3d4/8R5Ar4xKCsKooOHVOhAZ2vcGjQ5
 iUJFSC0dYZN5RDSH5btjnjE+R+O6+2oOgCxu93YgnFhjvutsCb+HsDapndKPOtH75e70=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Date:
 Subject:Cc:To:From:Sender:Reply-To:Content-ID:Content-Description:Resent-Date
 :Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:
 References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
 List-Owner:List-Archive; bh=JWU/bvQplpq32Knxv8Pox9YEw/v27hnBYemurc1ELJ8=; b=N
 vUSC8Q8Qj+IOCVwCMWHhovYhKfKjtNIEO6oAXSi6qChzxps6sDrnU+upZbLOO2c+FFdBbrFRqEdtd
 fvEld4fRFNkNm0k5QLkXQTNexjs5BwVMhNGuW8eoqpfSnPn9kbzgbXXHrX2LSaNMctcY1w7xiYL1y
 KciTMz+YWAngq64o=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2; 
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWU/bvQplpq32Knxv8Pox9YEw/v27hnBYemurc1ELJ8=;
 b=dLnAJvqv7qCszNP62jfkaIDObQxwd4JQeWVotpDkmRYHtutvGhR96r37/7GlvDxU1dN5nCGic13VoA5T7bHl2LXpydgd5p66WjWYNZkebZAMBi/eK/RhXLC1B29AU4380gVHX7QHqMbZRACmiHqCSE5Yd09lDmMfMNIR9HW0hfb8S+wqHPX+xga55XpXeHTm7b1oNqIhBYZCBEMPYf54vpb7S7zgAn4EgreDxagXs8WORHp89J00hXqSszk6SAznKF/Lli/cmLfZT8hT290PJuhqG8o4+XaC+Md6C/nEh6LaT+GbdigFq0+S/ac1elKAbtcNXxA318kEk2MU7W8vlg==
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
v3:
-convert to inline helper
v2:
-add kobject_del_and_put() users
 include/linux/kobject.h | 13 +++++++++++++
 lib/kobject.c           |  3 +--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index bdab370a24f4..e21b7c22e355 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -112,6 +112,19 @@ extern struct kobject * __must_check kobject_get_unless_zero(
 						struct kobject *kobj);
 extern void kobject_put(struct kobject *kobj);
 
+/**
+ * kobject_del_and_put() - Delete kobject.
+ * @kobj: object.
+ *
+ * Unlink kobject from hierarchy and decrement the refcount.
+ * If refcount is 0, call kobject_cleanup().
+ */
+static inline void kobject_del_and_put(struct kobject *kobj)
+{
+	kobject_del(kobj);
+	kobject_put(kobj);
+}
+
 extern const void *kobject_namespace(const struct kobject *kobj);
 extern void kobject_get_ownership(const struct kobject *kobj,
 				  kuid_t *uid, kgid_t *gid);
diff --git a/lib/kobject.c b/lib/kobject.c
index f79a434e1231..e6c5a3ff1c53 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -876,8 +876,7 @@ void kset_unregister(struct kset *k)
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
