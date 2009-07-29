From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Crash...
Date: Wed, 29 Jul 2009 11:46:04 +0900 (JST)
Message-ID: <20090729.114604.56042421.ryusuke@osrg.net>
References: <9cdbb57f0907230555k768383c2ld1690d31cc6fff83@mail.gmail.com>
	<20090724.011249.110726474.ryusuke@osrg.net>
	<9cdbb57f0907231402i1a92cb4qfe5a9d81346a4665@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Wed_Jul_29_11_46_04_2009_279)--"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <9cdbb57f0907231402i1a92cb4qfe5a9d81346a4665-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: andrea.gelmini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

----Next_Part(Wed_Jul_29_11_46_04_2009_279)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi Andrea,
On Thu, 23 Jul 2009 23:02:47 +0200, Andrea Gelmini wrote:
> 2009/7/23 Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>:
> > It also suggests that an inconsistent state in page cache of B-tree
> > nodes hit the function; the function found a dirty page, but the page
> > didn't have buffer heads which was supposed to be impossible for the
> > b-tree of nilfs.
> 
> Well,
>    thanks for your quick reply.
>    Anyway, I can reproduce the same problem doing same things with
> stable kernel (2.6.29.6) and nilfs2-module from git repository.
>    I do this:
>    -> mkfs.nilfs2 -b 1024 /dev/mapper/VG-NilfHome (maybe the problem
> is the 1K block size?)
>    -> mount /dev/mapper/VG-NilfHome /tmp/test/
>    -> I run mirrordir (here's exactly as a "cp -a")
> 
>    It stucks at the same file as the crash before.
>    It's a 5G file, if it could help.

I found a bug which may cause the kernel oops you reported.
The bug can arise only if buffer size is smaller than page size.

Here I attach the patch that will hopefully fix this problem.

Could you test if the patch makes a difference for the same file ?

Regards,
Ryusuke Konishi
---
 fs/nilfs2/segment.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 8b5e477..51ff3d0 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1859,12 +1859,26 @@ static void nilfs_end_page_io(struct page *page, int err)
 	if (!page)
 		return;
 
-	if (buffer_nilfs_node(page_buffers(page)) && !PageWriteback(page))
+	if (buffer_nilfs_node(page_buffers(page)) && !PageWriteback(page)) {
 		/*
 		 * For b-tree node pages, this function may be called twice
 		 * or more because they might be split in a segment.
 		 */
+		if (PageDirty(page)) {
+			/*
+			 * For pages holding split b-tree node buffers, dirty
+			 * flag on the buffers may be cleared discretely.
+			 * In that case, the page is once redirtied for
+			 * remaining buffers, and it must be cancelled if
+			 * all the buffers get cleaned later.
+			 */
+			lock_page(page);
+			if (nilfs_page_buffers_clean(page))
+				__nilfs_clear_page_dirty(page);
+			unlock_page(page);
+		}
 		return;
+	}
 
 	__nilfs_end_page_io(page, err);
 }
-- 
1.6.3.3


----Next_Part(Wed_Jul_29_11_46_04_2009_279)--
Content-Type: Application/Octet-Stream
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="nilfs2-fix-oops-due-to-inconsistent-page-state.patch.bz2"

QlpoOTFBWSZTWWCZ7tgAAVBfgEA4YX///X36XIq//9/+UAQ9O5umvV265rvZtrcNNIQ0mp+qnsjF
PUbVPU9qnjRR7VBhDIGh6ag/Ug0QaTaTQmgmJoyAADQAAAADTQgSaj1AGmTR6IAAAAABoAkSTSYR
qYozQhmgmCMRieiDAATaCU0gphU9qaeqaeTTyGqeppvVBjSGmIaGgBoMLEicA2McMgcNIgd+UCfd
8NAMF2aX/oz2qvnmBZJH3f7xZLHWSZD3zTfS1jadgNpC2qMx/VUbZ64ggq8prRQK0HQgEt2y527Z
rhnXm5P+ruMXjjxTzYbQ8HDMPy4ahHvXjcRK6ZpuxEY7EbXFuGcMarDnIGuaH5KQLqq7U6HXtS1s
bEisUC3ccLphTyriOJh4k2xs7eWtHi02JFlOBj2Sh7ueQR9NGS5coQLEqaWKZwew/pjpXZrruZLQ
qYH15WOomMHslnsUMOlVN4bZrHbvCpGCBCpgNMpPSQ8sauAUCyyhcZaIuSUy5qJK9ivGBNPcKea+
rHIkPElbV1oHjOyqiff17uu+NE1W2CAZeNgwETgZ0GCDhQejc2BXnc4ngukj3Fw0HaQNEXoZbwhl
QNEhgywTaYJo0rCNl4xkqwQv0VPkd9NKuTDbGyLRI0bYjFB1PiHZRfRpfVKI37dYB5k9gycBa3VB
PwxvhxUOaFBHzVRUU5ervJRZHah6Bd3b6ItyCQj9G4gesT8xTMTMkYvuNWwdrANACCxCgGi8iX0m
VVT7MeUxcxxmHhMrh3SjChjlEctuUgNhf35ImAmLhCR0nQGK89nJNsqnKxSzXxq2TZYpmVXWSGDb
HVZAuSgsRWyMOSmaJiA5CKq7Oe4WK2W66MMKsuAYIiYjFiyCBySZJKafKVJiAMEHTYEz5512BCAU
puIPE/5UwpeI40NeRa0ZAjRlycg94eKaWUmsHOExjxkduE++odIaEGaOimdFV/Azo8VF87dA1ep/
5Az0ODRljrBpVIDL8wdwZWXm0E0HYZn8jtCvH27w0LDiaeDg1y0gukkabNAjBvhFicRA8WbNbjCk
CVsaAWFuBKZZaSSgagUEgLgPNJDtUHhLeInN7DM0X3zJsuNDGoMl3ORjXer3mVhVp6av2IrKytoU
08km1T8vjGrbcqsdWBs0YKVOQlyEKB4AwIrZrVUNMdjs4qkyENzBlMrhDIGKVeNhahI3RrCuTSEQ
IoVbNwmsgZzfDgZqNsDj2bLSj+0VI6zEgSIkzMazvivLbbgSOD0jjZzr0jHcyQUbDurxLcVpRNih
4iFrS+ktRUFOFDWitsqM5vUqQjRFlbAJVMWMUStdAG6y2UjlK6sQTiVsIcOSFypZiCGm29Ssu1iq
QIgEUHHEfTEKaqSZowZ6oAXVlNQmWHoBOZJmJs8SIQS4ERYrJZYkcS2kOqwdJNu8lwPJ9t4FWGfb
Wlr6GNYyekHzlhh4SlgzIMuBs0FjGkqXmk1wrHCICKlUD/xdyRThQkGCZ7tg

----Next_Part(Wed_Jul_29_11_46_04_2009_279)--
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

----Next_Part(Wed_Jul_29_11_46_04_2009_279)----
