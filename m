From: Yuri Chislov <yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org>
Subject: Re: NILFS errors.
Date: Fri, 2 Oct 2009 18:57:28 +0200
Message-ID: <200910021857.28569.yuri@itinteg.net>
References: <200910021246.19909.yuri@itinteg.net>
	<20091002.205508.118939509.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20091002.205508.118939509.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

On Friday 02 October 2009 13:55:08 Ryusuke Konishi wrote:
> On Fri, 2 Oct 2009 12:46:19 +0200, Yuri Chislov <yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org> wrote:
> > Hi,
> >
> >   It's look, like corrupted file system.
> >
> >  Used kernel:
> >  2.6.31.1 +
> > "fix missing zero-fill initialization of btree node cache" patch +
> > "fix missing initialization of i_dir_start_lookup member" patch
> >
> > Errors in dmesg:
> > NILFS error (device md4): nilfs_check_page: bad entry in directory
> > #53267: unaligned directory entry - offset=0, inode=1970562386,
> > rec_len=29793, name_len=104
> > NILFS error (device md4): nilfs_readdir: bad page in #53267
> > NILFS error (device md4): nilfs_readdir: bad page in #53267
> > NILFS error (device md4): nilfs_readdir: bad page in #53267
> > NILFS error (device md4): nilfs_readdir: bad page in #53267
> > NILFS error (device md4): nilfs_readdir: bad page in #53267
> > init_special_inode: bogus i_mode (53563)
> > init_special_inode: bogus i_mode (52465)
> > init_special_inode: bogus i_mode (31155)
> > NILFS error (device md4): nilfs_readdir: bad page in #53267
> >
> > Commands output:
> >  ls -la
> > total 164
> > drwx------ 12 mik users  4096 2009-10-02 12:27 .
> > drwx------  3 mik users  4096 2004-11-04 12:05 ..
> > drwx------  6 mik users  4096 2009-09-27 03:11 .aaa Inbox Archive
> > drwx------  2 mik users  4096 2004-07-25 09:06 courierimapkeywords
> > drwx------  6 mik users  4096 2009-10-02 12:36 .Sent Archive
> >
> > ls -la .aaa\ Inbox\ Archive/
> > ls: reading directory .aaa Inbox Archive/: Input/output error
> >
> > ls -la .Sent\ Archive/
> > total 5932871552481704068
> > drwx------     6 mik        users                     4096 2009-10-02
> > 12:36 . drwx------    12 mik        users                     4096
> > 2009-10-02 12:27 .. cr-SrwSrwT 30768 1801873002 1496920692        1613,
> > 231244 2027-01-27 06:53 courierimapkeywords
> > dr-xrwSr-t 30062 1165184817  873096304 8671482274525501817 2026-01-19
> > 19:18 courierimapuiddb
> > drwx------     2 mik        users                     4096 2009-07-31
> > 15:21 cur
> > -rw-------     1 mik        users                    22528 2009-09-29
> > 10:05 dovecot.index.cache
> > -rw-------     1 mik        users                      896 2009-09-27
> > 22:50 dovecot.index.log
> > -rw-------     1 mik        users                     1126 2009-09-25
> > 14:26 dovecot-uidlist
> > ?--x-w-r-t 29739 1110729523  826363463 7235987552073157170 2033-05-31
> > 16:29 maildirfolder
> > ?r-xr---wt 22328  929450849 1399928645 4121162288830115449 1975-07-20
> > 07:56 new
> > drwx------     2 mik        users                     4096 2009-10-02
> > 12:20 tmp
> >
> > ls -la .Sent\ Archive/new
> > ?r-xr---wt 22328 929450849 1399928645 4121162288830115449 1975-07-20
> > 07:56 .Sent Archive/new
> 
> Grrr, my patch missed your problem? Sigh.
> 
> Didn't you see any write I/O errors before these messages?
> 
> Regards,
> Ryusuke Konishi
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
> 
Hi,

This is all, that I can find in logs:
The kernel was updated Oct 1.

Sep 27 02:17:28 gw-0 kernel: NILFS warning: mounting unchecked fs
Sep 27 02:17:28 gw-0 kernel: NILFS: recovery complete.
Sep 27 03:05:52 gw-0 kernel: NILFS warning: mounting unchecked fs
Sep 27 03:05:52 gw-0 kernel: NILFS: recovery complete.
Sep 27 19:09:04 gw-0 kernel: NILFS error (device md4): nilfs_check_page: bad 
entry in directory #22314: unaligned directory entry - offset=0, 
inode=1668369006, rec_len=19054, name_len=54
Sep 27 19:09:04 gw-0 kernel: NILFS error (device md4): nilfs_readdir: bad page 
in #22314
Sep 28 03:09:22 gw-0 kernel: NILFS error (device md4): nilfs_readdir: bad page 
in #22314
Sep 28 09:52:51 gw-0 kernel: NILFS error (device md4): nilfs_check_page: bad 
entry in directory #22310: unaligned directory entry - offset=0, 
inode=1047084094, rec_len=28787, name_len=97
Sep 28 11:17:42 gw-0 kernel: NILFS error (device md4): nilfs_readdir: bad page 
in #22310
Sep 28 11:18:25 gw-0 kernel: NILFS error (device md4): nilfs_readdir: bad page 
in #22310
Sep 28 14:16:36 gw-0 kernel: NILFS error (device md4): nilfs_readdir: bad page 
in #22310
Oct  1 17:06:03 gw-0 kernel: NILFS warning: mounting fs with errors
Oct  2 08:25:17 gw-0 kernel: NILFS error (device md4): nilfs_check_page: bad 
entry in directory #53267: unaligned directory entry - offset=0, 
inode=1970562386, rec_len=29793, name_len=104
Oct  2 12:27:06 gw-0 kernel: NILFS error (device md4): nilfs_readdir: bad page 
in #53267
Oct  2 12:27:07 gw-0 kernel: NILFS error (device md4): nilfs_readdir: bad page 
in #53267
Oct  2 12:27:08 gw-0 kernel: NILFS error (device md4): nilfs_readdir: bad page 
in #53267
Oct  2 12:27:09 gw-0 kernel: NILFS error (device md4): nilfs_readdir: bad page 
in #53267
Oct  2 12:27:09 gw-0 kernel: NILFS error (device md4): nilfs_readdir: bad page 
in #53267
Oct  2 12:31:44 gw-0 kernel: NILFS error (device md4): nilfs_readdir: bad page 
in #53267
Oct  2 12:38:37 gw-0 kernel: NILFS error (device md4): nilfs_readdir: bad page 
in #53267

Is it possible that the issue related to software raid(used RAID1)? 

Thank you.
Yuri. 
