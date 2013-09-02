From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH] [CRITICAL] nilfs2: fix issue with race condition of
 competition between segments for dirty blocks
Date: Tue, 03 Sep 2013 03:13:21 +0900 (JST)
Message-ID: <20130903.031321.52162146.konishi.ryusuke@lab.ntt.co.jp>
References: <1378128464.2327.20.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1378128464.2327.20.camel@slavad-ubuntu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, jeromepoulin@gmail.com, devel@antoneliasson.se, fercerpav@gmail.com, hermes@ceres.dti.ne.jp, szarpaj@grubelek.pl, Linux@riotingpacifist.net, zahid.chowdhury@starsolutions.com, freeboy6716@gmail.com, klangga@gmail.com, akpm@linux-foundation.org

On Mon, 02 Sep 2013 17:27:44 +0400, Vyacheslav Dubeyko wrote:
> From: Vyacheslav Dubeyko <slava@dubeyko.com>
> Subject: [PATCH] [CRITICAL] nilfs2: fix issue with race condition of =
competition between segments for dirty blocks

Before considering to apply this patch, please confirm that the
suspected issue, "dirty buffer_heads are added in several lists of
payload_buffers" you pointed out, is actually happening.

The easiest way for this is testing the following patch:

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index bd88a74..cab38db 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -668,6 +668,7 @@ static size_t nilfs_lookup_dirty_data_buffers(struc=
t inode *inode,
 			if (!buffer_dirty(bh))
 				continue;
 			get_bh(bh);
+			BUG_ON(!list_empty(&bh->b_assoc_buffers));
 			list_add_tail(&bh->b_assoc_buffers, listp);
 			ndirties++;
 			if (unlikely(ndirties >=3D nlimit)) {
@@ -701,6 +702,7 @@ static void nilfs_lookup_dirty_node_buffers(struct =
inode *inode,
 			do {
 				if (buffer_dirty(bh)) {
 					get_bh(bh);
+					BUG_ON(!list_empty(&bh->b_assoc_buffers));
 					list_add_tail(&bh->b_assoc_buffers,
 						      listp);
 				}

You can rewrite the above BUG_ON() check with the following debug code
if you want to get detail information on the buffer:

  if (!list_empty(&bh->b_assoc_buffers)) {
     /* dump information on bh */
  }

As a workaround, we can avoid double registration to different payload
lists with list_empty(&bh->b_assoc_buffers) instead of adding
BH_async_write flag.

However, I think we should first narrow down the root cause of why the
issue "dirty buffer_heads are added in several lists of
payload_buffers" happens.

We designed the log writer so that the same buffer is not registered
to two different payload buffer lists at the same time.  If it is not
satisfied, it's a bug.

What is the root cause of the "double registration" of a buffer head,
do you think?


Regards,
Ryusuke Konishi


> Many NILFS2 users were reported about strange file system corruption =
(for example):
>=20
> [129306.872119] NILFS: bad btree node (blocknr=3D185027): level =3D 0=
, flags =3D 0x0, nchildren =3D 768
> [129306.872127] NILFS error (device sda4): nilfs_bmap_last_key: broke=
n bmap (inode number=3D11540)
>=20
> But such error messages are consequence of file system's issue that t=
akes place
> more earlier. Fortunately, Jerome Poulin <jeromepoulin@gmail.com> and
> Anton Eliasson <devel@antoneliasson.se> were reported about another i=
ssue
> not so recently. These reports describe the issue with segctor thread=
's crash:
>=20
> [1677.310656] BUG: unable to handle kernel paging request at 00000000=
00004c83
> [1677.310683] IP: [<ffffffffa024d0f2>] nilfs_end_page_io+0x12/0xd0 [n=
ilfs2]
>=20
> [1677.311562] Call Trace:
> [1677.311575]  [<ffffffffa024e4c5>] nilfs_segctor_do_construct+0xf25/=
0x1b20 [nilfs2]
> [1677.311596]  [<ffffffff81019d09>] ? sched_clock+0x9/0x10
> [1677.311614]  [<ffffffffa024f3ab>] nilfs_segctor_construct+0x17b/0x2=
90 [nilfs2]
> [1677.311636]  [<ffffffffa024f5e2>] nilfs_segctor_thread+0x122/0x3b0 =
[nilfs2]
> [1677.311657]  [<ffffffffa024f4c0>] ?nilfs_segctor_construct+0x290/0x=
290 [nilfs2]
> [1677.311677]  [<ffffffff8107cae0>] kthread+0xc0/0xd0
> [1677.311690]  [<ffffffff8107ca20>] ? kthread_create_on_node+0x120/0x=
120
> [1677.311709]  [<ffffffff816dd16c>] ret_from_fork+0x7c/0xb0
> [1677.311724]  [<ffffffff8107ca20>] ? kthread_create_on_node+0x120/0x=
120
>=20
> These two issues have one reason. This reason can raise third issue t=
oo.
> Third issue results in hanging of segctor thread with eating of 100% =
CPU.
>=20
> REPRODUCING PATH:
> One of the possible way or the issue reproducing was described by
> J=C3=A9r=C3=B4me Poulin <jeromepoulin@gmail.com>:
>=20
> 1. init S to get to single user mode.
> 2. sysrq+E to make sure only my shell is running
> 3. start network-manager to get my wifi connection up
> 4. login as root and launch "screen"
> 5. cd /boot/log/nilfs which is a ext3 mount point and can log when NI=
LFS dies.
> 6. lscp | xz -9e > lscp.txt.xz
> 7. mount my snapshot using mount -o cp=3D3360839,ro /dev/vgUbuntu/roo=
t /mnt/nilfs
> 8. start a screen to dump /proc/kmsg to text file since rsyslog is ki=
lled
> 9. start a screen and launch strace -f -o find-cat.log -t find
> /mnt/nilfs -type f -exec cat {} > /dev/null \;
> 10. start a screen and launch strace -f -o apt-get.log -t apt-get upd=
ate
> 11. launch the last command again as it did not crash the first time
> 12. apt-get crashes
> 13. ps aux > ps-aux-crashed.log
> 13. sysrq+W
> 14. sysrq+E  wait for everything to terminate
> 15. sysrq+SUSB
>=20
> Simplified way of the issue reproducing is starting kernel compilatio=
n task
> and "apt-get update" in parallel.
>=20
> REPRODUCIBILITY:
> The issue is reproduced not stable [60% - 80%]. It is very important =
to have
> proper environment for the issue reproducing. The critical conditions=
 for
> successful reproducing:
> (1) It should have big modified file by mmap() way.
> (2) This file should have the count of dirty blocks are greater that =
several
> segments in size (for example, two or three) from time to time during
> processing.
> (3) It should be intensive background activity of files modification =
in
> another thread.
>=20
> INVESTIGATION:
> First of all, it is possible to see that the reason of crash is not v=
alid
> page address:
>=20
> [291.101244] NILFS [nilfs_segctor_complete_write]:2100 bh->b_count 0,=
 bh->b_blocknr 13895680, bh->b_size 13897727, bh->b_page 0000000000001a=
82
> [291.101249] NILFS [nilfs_segctor_complete_write]:2101 segbuf->sb_seg=
num 6783
>=20
> Moreover, value of b_page (0x1a82) is 6786. This value looks like seg=
ment
> number. And b_blocknr with b_size values look like block numbers. So,
> buffer_head's pointer points on not proper address value.
>=20
> Detailed investigation of the issue is discovered such picture:
>=20
> [-----------------------------SEGMENT 6783---------------------------=
----]
> [290.886448] NILFS [nilfs_segctor_do_construct]:2310 nilfs_segctor_be=
gin_construction
> [290.886460] NILFS [nilfs_segctor_do_construct]:2321 nilfs_segctor_co=
llect
> [290.886578] NILFS [nilfs_segctor_do_construct]:2336 nilfs_segctor_as=
sign
> [290.886601] NILFS [nilfs_segctor_do_construct]:2367 nilfs_segctor_up=
date_segusage
> [290.886608] NILFS [nilfs_segctor_do_construct]:2371 nilfs_segctor_pr=
epare_write
> [290.886631] NILFS [nilfs_segctor_do_construct]:2376 nilfs_add_checks=
ums_on_logs
> [290.886663] NILFS [nilfs_segctor_do_construct]:2381 nilfs_segctor_wr=
ite
> [290.886697] NILFS [nilfs_segbuf_submit_bio]:464 bio->bi_sector 11114=
9024, segbuf->sb_segnum 6783
>=20
> [-----------------------------SEGMENT 6784---------------------------=
----]
> [290.886755] NILFS [nilfs_segctor_do_construct]:2310 nilfs_segctor_be=
gin_construction
> [290.886765] NILFS [nilfs_segctor_do_construct]:2321 nilfs_segctor_co=
llect
> [290.952406] NILFS [nilfs_lookup_dirty_data_buffers]:782 bh->b_count =
1, bh->b_page ffffea000709b000, page->index 0, i_ino 1033103, i_size 25=
165824
> [290.952411] NILFS [nilfs_lookup_dirty_data_buffers]:783 bh->b_assoc_=
buffers.next ffff8802174a6798, bh->b_assoc_buffers.prev ffff880221cffee=
8
> [290.919399] NILFS [nilfs_segctor_do_construct]:2336 nilfs_segctor_as=
sign
> [290.932458] NILFS [nilfs_segctor_do_construct]:2367 nilfs_segctor_up=
date_segusage
> [290.933098] NILFS [nilfs_segctor_do_construct]:2371 nilfs_segctor_pr=
epare_write
> [290.939184] NILFS [nilfs_segctor_do_construct]:2376 nilfs_add_checks=
ums_on_logs
> [290.951133] NILFS [nilfs_segctor_do_construct]:2381 nilfs_segctor_wr=
ite
> [290.951314] NILFS [nilfs_segbuf_submit_bh]:575 bh->b_count 1, bh->b_=
page ffffea000709b000, page->index 0, i_ino 1033103, i_size 25165824
> [290.951321] NILFS [nilfs_segbuf_submit_bh]:576 segbuf->sb_segnum 678=
4
> [290.951325] NILFS [nilfs_segbuf_submit_bh]:577 bh->b_assoc_buffers.n=
ext ffff880218a0d5f8, bh->b_assoc_buffers.prev ffff880218bcdf50
> [290.951534] NILFS [nilfs_segbuf_submit_bio]:464 bio->bi_sector 11115=
0080, segbuf->sb_segnum 6784, segbuf->sb_nbio 0
> [----------] ditto
> [290.952308] NILFS [nilfs_segbuf_submit_bio]:464 bio->bi_sector 11116=
4416, segbuf->sb_segnum 6784, segbuf->sb_nbio 15
>=20
> [-----------------------------SEGMENT 6785---------------------------=
----]
> [290.952340] NILFS [nilfs_segctor_do_construct]:2310 nilfs_segctor_be=
gin_construction
> [290.952364] NILFS [nilfs_segctor_do_construct]:2321 nilfs_segctor_co=
llect
> [290.952406] NILFS [nilfs_lookup_dirty_data_buffers]:782 bh->b_count =
2, bh->b_page ffffea000709b000, page->index 0, i_ino 1033103, i_size 25=
165824
> [290.952411] NILFS [nilfs_lookup_dirty_data_buffers]:783 bh->b_assoc_=
buffers.next ffff880219277e80, bh->b_assoc_buffers.prev ffff880221cffc8=
8
> [290.990248] NILFS [nilfs_segctor_do_construct]:2367 nilfs_segctor_up=
date_segusage
> [290.990265] NILFS [nilfs_segctor_do_construct]:2371 nilfs_segctor_pr=
epare_write
> [291.008348] NILFS [nilfs_segctor_do_construct]:2376 nilfs_add_checks=
ums_on_logs
> [291.018110] NILFS [nilfs_segctor_do_construct]:2381 nilfs_segctor_wr=
ite
> [291.021206] NILFS [nilfs_segbuf_submit_bh]:575 bh->b_count 2, bh->b_=
page ffffea000709b000, page->index 0, i_ino 1033103, i_size 25165824
> [291.021210] NILFS [nilfs_segbuf_submit_bh]:576 segbuf->sb_segnum 678=
5
> [291.021214] NILFS [nilfs_segbuf_submit_bh]:577 bh->b_assoc_buffers.n=
ext ffff880218a0d5f8, bh->b_assoc_buffers.prev ffff880222cc7ee8
> [291.021241] NILFS [nilfs_segbuf_submit_bio]:464 bio->bi_sector 11116=
5440, segbuf->sb_segnum 6785, segbuf->sb_nbio 0
> [----------] ditto
> [291.021916] NILFS [nilfs_segbuf_submit_bio]:464 bio->bi_sector 11117=
7728, segbuf->sb_segnum 6785, segbuf->sb_nbio 12
>=20
> [291.021944] NILFS [nilfs_segctor_do_construct]:2399 nilfs_segctor_wa=
it
> [291.021950] NILFS [nilfs_segbuf_wait]:676 segbuf->sb_segnum 6783
> [291.021964] NILFS [nilfs_segbuf_wait]:676 segbuf->sb_segnum 6784
> [291.021984] NILFS [nilfs_segbuf_wait]:676 segbuf->sb_segnum 6785
>=20
> [291.071861] NILFS [nilfs_segctor_complete_write]:2100 bh->b_count 0,=
 bh->b_blocknr 13895680, bh->b_size 13897727, bh->b_page 0000000000001a=
82
>=20
> BUG: unable to handle kernel paging request at 0000000000001a82
> IP: [<ffffffffa024d0f2>] nilfs_end_page_io+0x12/0xd0 [nilfs2]
>=20
> Usually, for every segment we collect dirty files in list. Then, dirt=
y blocks
> are gathered for every dirty file, prepared for write and submitted b=
y means of
> nilfs_segbuf_submit_bh() call. Finally, it takes place complete write=
 phase
> after calling nilfs_end_bio_write() on the block layer. Buffers/pages
> are marked as not dirty on final phase and processed files removed fr=
om the
> list of dirty files.
>=20
> It is possible to see that we had three prepare_write and submit_bio =
phases
> before segbuf_wait and complete_write phase. Moreover, segments compe=
te
> between each other for dirty blocks because on every iteration of seg=
ments
> processing dirty buffer_heads are added in several lists of payload_b=
uffers:
>=20
> [SEGMENT 6784]: bh->b_assoc_buffers.next ffff880218a0d5f8, bh->b_asso=
c_buffers.prev ffff880218bcdf50
> [SEGMENT 6785]: bh->b_assoc_buffers.next ffff880218a0d5f8, bh->b_asso=
c_buffers.prev ffff880222cc7ee8
>=20
> The next pointer is the same but prev pointer has changed. It means t=
hat
> buffer_head has next pointer from one list but prev pointer from anot=
her.
> Such modification can be made several times. And, finally,
> it can be resulted in various issues: (1) segctor hanging, (2) segcto=
r
> crashing, (3) file system metadata corruption.
>=20
> FIX:
> This patch adds:
> (1) setting of BH_Async_Write flag in nilfs_segctor_prepare_write()
> for every proccessed dirty block;
> (2) checking of BH_Async_Write flag in nilfs_lookup_dirty_data_buffer=
s() and
> nilfs_lookup_dirty_node_buffers();
> (3) clearing of BH_Async_Write flag in nilfs_segctor_complete_write()=
,
> nilfs_abort_logs(), nilfs_forget_buffer(), nilfs_clear_dirty_page().
>=20
> Reported-by: Jerome Poulin <jeromepoulin@gmail.com>
> Reported-by: Anton Eliasson <devel@antoneliasson.se>
> CC: Paul Fertser <fercerpav@gmail.com>
> CC: ARAI Shun-ichi <hermes@ceres.dti.ne.jp>
> CC: Piotr Szymaniak <szarpaj@grubelek.pl>
> CC: Juan Barry Manuel Canham <Linux@riotingpacifist.net>
> CC: Zahid Chowdhury <zahid.chowdhury@starsolutions.com>
> CC: Elmer Zhang <freeboy6716@gmail.com>
> CC: Kenneth Langga <klangga@gmail.com>
> Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
> CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
>  fs/nilfs2/page.c    |    2 ++
>  fs/nilfs2/segment.c |   11 +++++++++--
>  2 files changed, 11 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index 0ba6798..da27664 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -94,6 +94,7 @@ void nilfs_forget_buffer(struct buffer_head *bh)
>  	clear_buffer_nilfs_volatile(bh);
>  	clear_buffer_nilfs_checked(bh);
>  	clear_buffer_nilfs_redirected(bh);
> +	clear_buffer_async_write(bh);
>  	clear_buffer_dirty(bh);
>  	if (nilfs_page_buffers_clean(page))
>  		__nilfs_clear_page_dirty(page);
> @@ -429,6 +430,7 @@ void nilfs_clear_dirty_page(struct page *page, bo=
ol silent)
>  					"discard block %llu, size %zu",
>  					(u64)bh->b_blocknr, bh->b_size);
>  			}
> +			clear_buffer_async_write(bh);
>  			clear_buffer_dirty(bh);
>  			clear_buffer_nilfs_volatile(bh);
>  			clear_buffer_nilfs_checked(bh);
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index bd88a74..9f6b486 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -665,7 +665,7 @@ static size_t nilfs_lookup_dirty_data_buffers(str=
uct inode *inode,
> =20
>  		bh =3D head =3D page_buffers(page);
>  		do {
> -			if (!buffer_dirty(bh))
> +			if (!buffer_dirty(bh) || buffer_async_write(bh))
>  				continue;
>  			get_bh(bh);
>  			list_add_tail(&bh->b_assoc_buffers, listp);
> @@ -699,7 +699,8 @@ static void nilfs_lookup_dirty_node_buffers(struc=
t inode *inode,
>  		for (i =3D 0; i < pagevec_count(&pvec); i++) {
>  			bh =3D head =3D page_buffers(pvec.pages[i]);
>  			do {
> -				if (buffer_dirty(bh)) {
> +				if (buffer_dirty(bh) &&
> +						!buffer_async_write(bh)) {
>  					get_bh(bh);
>  					list_add_tail(&bh->b_assoc_buffers,
>  						      listp);
> @@ -1579,6 +1580,7 @@ static void nilfs_segctor_prepare_write(struct =
nilfs_sc_info *sci)
> =20
>  		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
>  				    b_assoc_buffers) {
> +			set_buffer_async_write(bh);
>  			if (bh->b_page !=3D bd_page) {
>  				if (bd_page) {
>  					lock_page(bd_page);
> @@ -1592,6 +1594,7 @@ static void nilfs_segctor_prepare_write(struct =
nilfs_sc_info *sci)
> =20
>  		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
>  				    b_assoc_buffers) {
> +			set_buffer_async_write(bh);
>  			if (bh =3D=3D segbuf->sb_super_root) {
>  				if (bh->b_page !=3D bd_page) {
>  					lock_page(bd_page);
> @@ -1677,6 +1680,7 @@ static void nilfs_abort_logs(struct list_head *=
logs, int err)
>  	list_for_each_entry(segbuf, logs, sb_list) {
>  		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
>  				    b_assoc_buffers) {
> +			clear_buffer_async_write(bh);
>  			if (bh->b_page !=3D bd_page) {
>  				if (bd_page)
>  					end_page_writeback(bd_page);
> @@ -1686,6 +1690,7 @@ static void nilfs_abort_logs(struct list_head *=
logs, int err)
> =20
>  		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
>  				    b_assoc_buffers) {
> +			clear_buffer_async_write(bh);
>  			if (bh =3D=3D segbuf->sb_super_root) {
>  				if (bh->b_page !=3D bd_page) {
>  					end_page_writeback(bd_page);
> @@ -1755,6 +1760,7 @@ static void nilfs_segctor_complete_write(struct=
 nilfs_sc_info *sci)
>  				    b_assoc_buffers) {
>  			set_buffer_uptodate(bh);
>  			clear_buffer_dirty(bh);
> +			clear_buffer_async_write(bh);
>  			if (bh->b_page !=3D bd_page) {
>  				if (bd_page)
>  					end_page_writeback(bd_page);
> @@ -1776,6 +1782,7 @@ static void nilfs_segctor_complete_write(struct=
 nilfs_sc_info *sci)
>  				    b_assoc_buffers) {
>  			set_buffer_uptodate(bh);
>  			clear_buffer_dirty(bh);
> +			clear_buffer_async_write(bh);
>  			clear_buffer_delay(bh);
>  			clear_buffer_nilfs_volatile(bh);
>  			clear_buffer_nilfs_redirected(bh);
> --=20
> 1.7.9.5
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
