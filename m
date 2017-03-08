From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v2 7/9] mm: ensure that we set mapping error if writeout() fails
Date: Wed,  8 Mar 2017 11:29:32 -0500
Message-ID: <20170308162934.21989-8-jlayton@redhat.com>
References: <20170308162934.21989-1-jlayton@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170308162934.21989-1-jlayton@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: viro@zeniv.linux.org.uk, akpm@linux-foundation.org
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, ross.zwisler@linux.intel.com, jack@suse.cz, neilb@suse.com, openosd@gmail.com, adilger@dilger.ca, James.Bottomley@HansenPartnership.com

If writepage fails during a page migration, then we need to ensure that
fsync will see it by flagging the mapping.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 mm/migrate.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 9a0897a14d37..a9c0b46865b7 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -789,7 +789,11 @@ static int writeout(struct address_space *mapping, struct page *page)
 		/* unlocked. Relock */
 		lock_page(page);
 
-	return (rc < 0) ? -EIO : -EAGAIN;
+	if (rc < 0) {
+		mapping_set_error(mapping, rc);
+		return -EIO;
+	}
+	return -EAGAIN;
 }
 
 /*
-- 
2.9.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
