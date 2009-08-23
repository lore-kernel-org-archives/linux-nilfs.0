From: Yuri Chislov <yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org>
Subject: Re: Fail to mount NILFS.
Date: Sun, 23 Aug 2009 16:06:17 +0300
Message-ID: <200908231606.17747.yuri@itinteg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_J7TkKd6kq01B49Y"
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

--Boundary-00=_J7TkKd6kq01B49Y
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Resend to mailing list.
On Sunday 23 August 2009 11:20:53 you wrote:
> And, the attached patch will output some information about how disk
> block numbers are converted with DAT file.
>
> I think this will give another hint on which metadata broke in nilfs.
>
> Could you apply it and try mount again?
Done.

104       17  209720511 cciss/c0d1p1
expr 209720511 / 4 / 2048 - 1
25599
./find_root.sh /dev/cciss/c0d1p1 25599
find_root.sh: root inode not found

Attached dmesg output.

Thanks.
Yuri.


--Boundary-00=_J7TkKd6kq01B49Y
Content-Type: text/plain;
  charset="utf-8";
  name="dmesg.output"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.output"

NILFS: corrupt root inode.
NILFS: looking segment (seg_start=22401024, seg_end=22403071, segnum=10938, seg_seq=62136)
NILFS: found super root: segnum=10938, seq=62136, pseg_start=22401723, pseg_offset=730
NILFS: latest checkpoint=30778
nilfs_btnode_submit_block: read ino=3 vblocknr=22401752 blocknr=22401752
nilfs_btnode_submit_block: read ino=3 vblocknr=22401750 blocknr=22401750
nilfs_mdt_submit_block lookup: ino=3 blkoff=25589 blknum=22401741
nilfs_mdt_submit_block lookup: ino=3 blkoff=25590 blknum=20023970
nilfs_mdt_submit_block lookup: ino=3 blkoff=25591 blknum=20015776
nilfs_mdt_submit_block lookup: ino=3 blkoff=25592 blknum=20077247
nilfs_mdt_submit_block lookup: ino=3 blkoff=25593 blknum=21061324
nilfs_mdt_submit_block lookup: ino=3 blkoff=25594 blknum=21061325
nilfs_mdt_submit_block lookup: ino=3 blkoff=25595 blknum=20417338
nilfs_mdt_submit_block lookup: ino=3 blkoff=25596 blknum=20392792
nilfs_mdt_submit_block lookup: ino=3 blkoff=25597 blknum=20602217
nilfs_mdt_submit_block lookup: ino=3 blkoff=25598 blknum=21061326
nilfs_mdt_submit_block lookup: ino=3 blkoff=25599 blknum=21061327
nilfs_mdt_submit_block lookup: ino=3 blkoff=25600 blknum=20975305
nilfs_mdt_submit_block lookup: ino=3 blkoff=25601 blknum=20967082
nilfs_mdt_submit_block lookup: ino=3 blkoff=25602 blknum=21126881
nilfs_mdt_submit_block lookup: ino=3 blkoff=25603 blknum=20634953
nilfs_mdt_submit_block lookup: ino=3 blkoff=25604 blknum=20593993
nilfs_dat_translate: vblocknr=3262527 -> blocknr=22401729
nilfs_btnode_submit_block: read ino=4 vblocknr=3262527 blocknr=22401729
nilfs_btnode_submit_block: read ino=3 vblocknr=22401749 blocknr=22401749
nilfs_mdt_submit_block lookup: ino=3 blkoff=25446 blknum=20606318
nilfs_mdt_submit_block lookup: ino=3 blkoff=25447 blknum=20593987
nilfs_mdt_submit_block lookup: ino=3 blkoff=25448 blknum=21028552
nilfs_mdt_submit_block lookup: ino=3 blkoff=25449 blknum=21335832
nilfs_mdt_submit_block lookup: ino=3 blkoff=25450 blknum=20921992
nilfs_mdt_submit_block lookup: ino=3 blkoff=25451 blknum=20921993
nilfs_mdt_submit_block lookup: ino=3 blkoff=25452 blknum=19983010
nilfs_mdt_submit_block lookup: ino=3 blkoff=25453 blknum=21869087
nilfs_mdt_submit_block lookup: ino=3 blkoff=25454 blknum=20323108
nilfs_mdt_submit_block lookup: ino=3 blkoff=25455 blknum=20495207
nilfs_mdt_submit_block lookup: ino=3 blkoff=25456 blknum=20581411
nilfs_mdt_submit_block lookup: ino=3 blkoff=25457 blknum=20745683
nilfs_mdt_submit_block lookup: ino=3 blkoff=25458 blknum=22397612
nilfs_mdt_submit_block lookup: ino=3 blkoff=25459 blknum=21003983
nilfs_mdt_submit_block lookup: ino=3 blkoff=25460 blknum=21176067
nilfs_mdt_submit_block lookup: ino=3 blkoff=25461 blknum=21352218
nilfs_dat_translate: vblocknr=3244247 -> blocknr=20603353
nilfs_mdt_submit_block lookup: ino=4 blkoff=241 blknum=20603353
nilfs_btnode_submit_block: read ino=3 vblocknr=22401751 blocknr=22401751
nilfs_mdt_submit_block lookup: ino=3 blkoff=25826 blknum=22401745
nilfs_mdt_submit_block lookup: ino=3 blkoff=25827 blknum=20634960
nilfs_mdt_submit_block lookup: ino=3 blkoff=25828 blknum=21155593
nilfs_mdt_submit_block lookup: ino=3 blkoff=25829 blknum=21680660
nilfs_mdt_submit_block lookup: ino=3 blkoff=25830 blknum=22205035
nilfs_mdt_submit_block lookup: ino=3 blkoff=25831 blknum=19942046
nilfs_mdt_submit_block lookup: ino=3 blkoff=25832 blknum=20470634
nilfs_mdt_submit_block lookup: ino=3 blkoff=25833 blknum=20999888
nilfs_mdt_submit_block lookup: ino=3 blkoff=25834 blknum=21524975
nilfs_mdt_submit_block lookup: ino=3 blkoff=25835 blknum=22049363
nilfs_mdt_submit_block lookup: ino=3 blkoff=25836 blknum=19786311
nilfs_mdt_submit_block lookup: ino=3 blkoff=25837 blknum=20314919
nilfs_mdt_submit_block lookup: ino=3 blkoff=25838 blknum=20840030
nilfs_mdt_submit_block lookup: ino=3 blkoff=25839 blknum=21368604
nilfs_mdt_submit_block lookup: ino=3 blkoff=25840 blknum=21893675
nilfs_mdt_submit_block lookup: ino=3 blkoff=25841 blknum=19634717
nilfs_dat_translate: vblocknr=3292780 -> blocknr=22401727
nilfs_mdt_submit_block lookup: ino=4 blkoff=0 blknum=22401727
nilfs_mdt_submit_block lookup: ino=3 blkoff=25417 blknum=22254189
nilfs_mdt_submit_block lookup: ino=3 blkoff=25418 blknum=21611014
nilfs_mdt_submit_block lookup: ino=3 blkoff=25419 blknum=21459426
nilfs_mdt_submit_block lookup: ino=3 blkoff=25420 blknum=21167869
nilfs_mdt_submit_block lookup: ino=3 blkoff=25421 blknum=20515697
nilfs_mdt_submit_block lookup: ino=3 blkoff=25422 blknum=20499307
nilfs_mdt_submit_block lookup: ino=3 blkoff=25423 blknum=20864598
nilfs_mdt_submit_block lookup: ino=3 blkoff=25424 blknum=20844113
nilfs_mdt_submit_block lookup: ino=3 blkoff=25425 blknum=20864599
nilfs_mdt_submit_block lookup: ino=3 blkoff=25426 blknum=20864600
nilfs_mdt_submit_block lookup: ino=3 blkoff=25427 blknum=22401739
nilfs_mdt_submit_block lookup: ino=3 blkoff=25428 blknum=20614524
nilfs_mdt_submit_block lookup: ino=3 blkoff=25429 blknum=21298959
nilfs_mdt_submit_block lookup: ino=3 blkoff=25430 blknum=21664292
nilfs_mdt_submit_block lookup: ino=3 blkoff=25431 blknum=21611016
nilfs_mdt_submit_block lookup: ino=3 blkoff=25432 blknum=21910050
nilfs_dat_translate: vblocknr=3240647 -> blocknr=20617314
nilfs_btnode_submit_block: read ino=6 vblocknr=3240647 blocknr=20617314
nilfs_mdt_submit_block lookup: ino=3 blkoff=25416 blknum=22241917
nilfs_dat_translate: vblocknr=3240498 -> blocknr=3280927
nilfs_mdt_submit_block lookup: ino=6 blkoff=2 blknum=3280927
nilfs_dat_translate: vblocknr=3240490 -> blocknr=20843792
nilfs_mdt_submit_block lookup: ino=6 blkoff=3 blknum=20843792
nilfs_dat_translate: vblocknr=3240646 -> blocknr=20617313
nilfs_mdt_submit_block lookup: ino=6 blkoff=4 blknum=20617313
nilfs_dat_translate: vblocknr=3240678 -> blocknr=20621795
nilfs_mdt_submit_block lookup: ino=6 blkoff=5 blknum=20621795
nilfs_dat_translate: vblocknr=3240679 -> blocknr=20621796
nilfs_mdt_submit_block lookup: ino=6 blkoff=6 blknum=20621796
nilfs_dat_translate: vblocknr=3240697 -> blocknr=20621797
nilfs_mdt_submit_block lookup: ino=6 blkoff=7 blknum=20621797
nilfs_dat_translate: vblocknr=3240652 -> blocknr=20621776
nilfs_mdt_submit_block lookup: ino=6 blkoff=8 blknum=20621776
nilfs_dat_translate: vblocknr=3240653 -> blocknr=20621777
nilfs_mdt_submit_block lookup: ino=6 blkoff=9 blknum=20621777
nilfs_dat_translate: vblocknr=3240654 -> blocknr=20621778
nilfs_mdt_submit_block lookup: ino=6 blkoff=10 blknum=20621778
nilfs_dat_translate: vblocknr=3240655 -> blocknr=20621779
nilfs_mdt_submit_block lookup: ino=6 blkoff=11 blknum=20621779
nilfs_dat_translate: vblocknr=3240656 -> blocknr=20621780
nilfs_mdt_submit_block lookup: ino=6 blkoff=12 blknum=20621780
nilfs_dat_translate: vblocknr=3240657 -> blocknr=20621781
nilfs_mdt_submit_block lookup: ino=6 blkoff=13 blknum=20621781
nilfs_dat_translate: vblocknr=3240658 -> blocknr=20621782
nilfs_mdt_submit_block lookup: ino=6 blkoff=14 blknum=20621782
nilfs_dat_translate: vblocknr=3240659 -> blocknr=20621783
nilfs_mdt_submit_block lookup: ino=6 blkoff=15 blknum=20621783
nilfs_dat_translate: vblocknr=3240660 -> blocknr=20621784
nilfs_mdt_submit_block lookup: ino=6 blkoff=16 blknum=20621784
nilfs_dat_translate: vblocknr=3240661 -> blocknr=20621785
nilfs_mdt_submit_block lookup: ino=6 blkoff=17 blknum=20621785
NILFS: corrupt root inode.

--Boundary-00=_J7TkKd6kq01B49Y
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--Boundary-00=_J7TkKd6kq01B49Y--
