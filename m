From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH] nilfs2: do not use unexported cpu_to_le32()/le32_to_cpu() in uapi header
Date: Wed,  5 Jun 2019 14:30:06 +0900
Message-ID: <20190605053006.14332-1-yamada.masahiro@socionext.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-12.nifty.com x555UAE8001144
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1559712611;
        bh=vIsvVdWf1BBkZws01DfQPUbAu87IXpqK2p7t7RStVSs=;
        h=From:To:Cc:Subject:Date:From;
        b=gMWlqo2qXDYYgeX7TYIEYiiw4hICHiZNgr+lDSPs4ZvaffjYGqPLJ7tr8nbEmwm6y
         6h61Ahd/9pNcTBRffwoIEuzk9pMkIT8NNE9PWPlAuB+fS/lPHE5SPEOwKuRR9ClNk/
         aTUXkD8UZO0lu8abr1wWwTCfRi1eRLBsoeeua1M+//Ts5BAKnn1PT5sJ+lD8Tqaxj5
         xWeGvsi5g+6kSEnvl85aYBDIEX9nKctH1pVVeXgD5WCqu4lHE4EhtfDWFYaG4Ya/uV
         nXfPw7Px6kJwj2Y0hR6eDDurKAJZy+eqUjcvG+sjweatdKp0XUIDMtYxw4Yt61nvTh
         cqbof4fGWREPw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>, Joe Perches <joe@perches.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kernel@vger.kernel.org

cpu_to_le32/le32_to_cpu is defined in include/linux/byteorder/generic.h,
which is not exported to user-space.

UAPI headers must use the ones prefixed with double-underscore.

Detected by compile-testing exported headers:

./usr/include/linux/nilfs2_ondisk.h: In function ‘nilfs_checkpoint_set_snapshot’:
./usr/include/linux/nilfs2_ondisk.h:536:17: error: implicit declaration of function ‘cpu_to_le32’ [-Werror=implicit-function-declaration]
  cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) |  \
                 ^
./usr/include/linux/nilfs2_ondisk.h:552:1: note: in expansion of macro ‘NILFS_CHECKPOINT_FNS’
 NILFS_CHECKPOINT_FNS(SNAPSHOT, snapshot)
 ^~~~~~~~~~~~~~~~~~~~
./usr/include/linux/nilfs2_ondisk.h:536:29: error: implicit declaration of function ‘le32_to_cpu’ [-Werror=implicit-function-declaration]
  cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) |  \
                             ^
./usr/include/linux/nilfs2_ondisk.h:552:1: note: in expansion of macro ‘NILFS_CHECKPOINT_FNS’
 NILFS_CHECKPOINT_FNS(SNAPSHOT, snapshot)
 ^~~~~~~~~~~~~~~~~~~~
./usr/include/linux/nilfs2_ondisk.h: In function ‘nilfs_segment_usage_set_clean’:
./usr/include/linux/nilfs2_ondisk.h:622:19: error: implicit declaration of function ‘cpu_to_le64’ [-Werror=implicit-function-declaration]
  su->su_lastmod = cpu_to_le64(0);
                   ^~~~~~~~~~~

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 include/uapi/linux/nilfs2_ondisk.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/nilfs2_ondisk.h b/include/uapi/linux/nilfs2_ondisk.h
index a7e66ab11d1d..c23f91ae5fe8 100644
--- a/include/uapi/linux/nilfs2_ondisk.h
+++ b/include/uapi/linux/nilfs2_ondisk.h
@@ -29,7 +29,7 @@
 
 #include <linux/types.h>
 #include <linux/magic.h>
-
+#include <asm/byteorder.h>
 
 #define NILFS_INODE_BMAP_SIZE	7
 
@@ -533,19 +533,19 @@ enum {
 static inline void							\
 nilfs_checkpoint_set_##name(struct nilfs_checkpoint *cp)		\
 {									\
-	cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) |		\
-				   (1UL << NILFS_CHECKPOINT_##flag));	\
+	cp->cp_flags = __cpu_to_le32(__le32_to_cpu(cp->cp_flags) |	\
+				     (1UL << NILFS_CHECKPOINT_##flag));	\
 }									\
 static inline void							\
 nilfs_checkpoint_clear_##name(struct nilfs_checkpoint *cp)		\
 {									\
-	cp->cp_flags = cpu_to_le32(le32_to_cpu(cp->cp_flags) &		\
+	cp->cp_flags = __cpu_to_le32(__le32_to_cpu(cp->cp_flags) &	\
 				   ~(1UL << NILFS_CHECKPOINT_##flag));	\
 }									\
 static inline int							\
 nilfs_checkpoint_##name(const struct nilfs_checkpoint *cp)		\
 {									\
-	return !!(le32_to_cpu(cp->cp_flags) &				\
+	return !!(__le32_to_cpu(cp->cp_flags) &				\
 		  (1UL << NILFS_CHECKPOINT_##flag));			\
 }
 
@@ -595,20 +595,20 @@ enum {
 static inline void							\
 nilfs_segment_usage_set_##name(struct nilfs_segment_usage *su)		\
 {									\
-	su->su_flags = cpu_to_le32(le32_to_cpu(su->su_flags) |		\
+	su->su_flags = __cpu_to_le32(__le32_to_cpu(su->su_flags) |	\
 				   (1UL << NILFS_SEGMENT_USAGE_##flag));\
 }									\
 static inline void							\
 nilfs_segment_usage_clear_##name(struct nilfs_segment_usage *su)	\
 {									\
 	su->su_flags =							\
-		cpu_to_le32(le32_to_cpu(su->su_flags) &			\
+		__cpu_to_le32(__le32_to_cpu(su->su_flags) &		\
 			    ~(1UL << NILFS_SEGMENT_USAGE_##flag));      \
 }									\
 static inline int							\
 nilfs_segment_usage_##name(const struct nilfs_segment_usage *su)	\
 {									\
-	return !!(le32_to_cpu(su->su_flags) &				\
+	return !!(__le32_to_cpu(su->su_flags) &				\
 		  (1UL << NILFS_SEGMENT_USAGE_##flag));			\
 }
 
@@ -619,15 +619,15 @@ NILFS_SEGMENT_USAGE_FNS(ERROR, error)
 static inline void
 nilfs_segment_usage_set_clean(struct nilfs_segment_usage *su)
 {
-	su->su_lastmod = cpu_to_le64(0);
-	su->su_nblocks = cpu_to_le32(0);
-	su->su_flags = cpu_to_le32(0);
+	su->su_lastmod = __cpu_to_le64(0);
+	su->su_nblocks = __cpu_to_le32(0);
+	su->su_flags = __cpu_to_le32(0);
 }
 
 static inline int
 nilfs_segment_usage_clean(const struct nilfs_segment_usage *su)
 {
-	return !le32_to_cpu(su->su_flags);
+	return !__le32_to_cpu(su->su_flags);
 }
 
 /**
-- 
2.17.1

