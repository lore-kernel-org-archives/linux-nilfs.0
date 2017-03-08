From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v2 3/9] mm: clear any AS_* errors when returning error on any fsync or close
Date: Wed,  8 Mar 2017 11:29:28 -0500
Message-ID: <20170308162934.21989-4-jlayton@redhat.com>
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

Currently we don't clear the address space error when there is a -EIO
error on fsynci, due to writeback initiation failure. If writes fail
with -EIO and the mapping is flagged with an AS_EIO or AS_ENOSPC error,
then we can end up returning errors on two fsync calls, even when a
write between them succeeded (or there was no write).

Ensure that we also clear out any mapping errors when initiating
writeback fails with -EIO in filemap_write_and_wait and
filemap_write_and_wait_range.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 mm/filemap.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 1694623a6289..fc123b9833e1 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -488,7 +488,7 @@ EXPORT_SYMBOL(filemap_fdatawait);
 
 int filemap_write_and_wait(struct address_space *mapping)
 {
-	int err = 0;
+	int err;
 
 	if ((!dax_mapping(mapping) && mapping->nrpages) ||
 	    (dax_mapping(mapping) && mapping->nrexceptional)) {
@@ -499,10 +499,18 @@ int filemap_write_and_wait(struct address_space *mapping)
 		 * But the -EIO is special case, it may indicate the worst
 		 * thing (e.g. bug) happened, so we avoid waiting for it.
 		 */
-		if (err != -EIO) {
+		if (likely(err != -EIO)) {
 			int err2 = filemap_fdatawait(mapping);
 			if (!err)
 				err = err2;
+		} else {
+			/*
+			 * Clear the error in the address space since we're
+			 * returning an error here. -EIO takes precedence over
+			 * everything else though, so we can just discard
+			 * the return here.
+			 */
+			filemap_check_errors(mapping);
 		}
 	} else {
 		err = filemap_check_errors(mapping);
@@ -537,6 +545,14 @@ int filemap_write_and_wait_range(struct address_space *mapping,
 						lstart, lend);
 			if (!err)
 				err = err2;
+		} else {
+			/*
+			 * Clear the error in the address space since we're
+			 * returning an error here. -EIO takes precedence over
+			 * everything else though, so we can just discard
+			 * the return here.
+			 */
+			filemap_check_errors(mapping);
 		}
 	} else {
 		err = filemap_check_errors(mapping);
-- 
2.9.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
