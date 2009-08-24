From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Fail to mount NILFS.
Date: Tue, 25 Aug 2009 01:08:47 +0900 (JST)
Message-ID: <20090825.010847.29421896.ryusuke@osrg.net>
References: <200908231606.17747.yuri@itinteg.net>
	<20090823.220941.57456918.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090823.220941.57456918.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org

Hi Yuri,
On Sun, 23 Aug 2009 22:09:41 +0900 (JST), Ryusuke Konishi wrote:
> I'll resend to the list, too.
> On Sun, 23 Aug 2009 16:06:17 +0300, Yuri Chislov wrote:
> > Resend to mailing list.
> > On Sunday 23 August 2009 11:20:53 you wrote:
> > > And, the attached patch will output some information about how disk
> > > block numbers are converted with DAT file.
> > >
> > > I think this will give another hint on which metadata broke in nilfs.
> > >
> > > Could you apply it and try mount again?
> > Done.
> > 
> > 104       17  209720511 cciss/c0d1p1
> > expr 209720511 / 4 / 2048 - 1
> > 25599
> > ./find_root.sh /dev/cciss/c0d1p1 25599
> > find_root.sh: root inode not found
> > 
> > Attached dmesg output.
> > 
> > Thanks.
> > Yuri.
> > 
> 
> Thank you for your cooperation.
> I'll look into the dmesg output.
> 
> Thanks,
> Ryusuke Konishi

I found the location of the root inode in your log.

> nilfs_dat_translate: vblocknr=3240647 -> blocknr=20617314
> nilfs_btnode_submit_block: read ino=6 vblocknr=3240647 blocknr=20617314
> nilfs_mdt_submit_block lookup: ino=3 blkoff=25416 blknum=22241917
> nilfs_dat_translate: vblocknr=3240498 -> blocknr=3280927
> nilfs_mdt_submit_block lookup: ino=6 blkoff=2 blknum=3280927
                                 ^^^^^       ^^        ^^^^^^^
                                 ifile       |
                                             `-- Offset of the block in
                                                 which the root inode is
                                                 written.

Could you send me the two dump files taken by the following steps ?

 # dd if=/dev/cciss/c0d1p1 bs=4k count=1 skip=3280927 | hd > blk3280927.log
 # expr 3280927 / 2048
 1602
 # dumpseg /dev/cciss/c0d1p1 1602 > seg1602.log


Thanks,
Ryusuke Konishi
