From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: NILFS errors.
Date: Fri, 02 Oct 2009 20:55:08 +0900 (JST)
Message-ID: <20091002.205508.118939509.ryusuke@osrg.net>
References: <200910021246.19909.yuri@itinteg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <200910021246.19909.yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org>
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

On Fri, 2 Oct 2009 12:46:19 +0200, Yuri Chislov <yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org> wrote:
> Hi,
> 
>   It's look, like corrupted file system.
> 
>  Used kernel:
>  2.6.31.1 + 
> "fix missing zero-fill initialization of btree node cache" patch +
> "fix missing initialization of i_dir_start_lookup member" patch
> 
> Errors in dmesg:
> NILFS error (device md4): nilfs_check_page: bad entry in directory #53267: 
> unaligned directory entry - offset=0, inode=1970562386, rec_len=29793, 
> name_len=104
> NILFS error (device md4): nilfs_readdir: bad page in #53267
> NILFS error (device md4): nilfs_readdir: bad page in #53267
> NILFS error (device md4): nilfs_readdir: bad page in #53267
> NILFS error (device md4): nilfs_readdir: bad page in #53267
> NILFS error (device md4): nilfs_readdir: bad page in #53267
> init_special_inode: bogus i_mode (53563)
> init_special_inode: bogus i_mode (52465)
> init_special_inode: bogus i_mode (31155)
> NILFS error (device md4): nilfs_readdir: bad page in #53267
>
> Commands output:
>  ls -la
> total 164
> drwx------ 12 mik users  4096 2009-10-02 12:27 .
> drwx------  3 mik users  4096 2004-11-04 12:05 ..
> drwx------  6 mik users  4096 2009-09-27 03:11 .aaa Inbox Archive
> drwx------  2 mik users  4096 2004-07-25 09:06 courierimapkeywords
> drwx------  6 mik users  4096 2009-10-02 12:36 .Sent Archive
> 
> ls -la .aaa\ Inbox\ Archive/
> ls: reading directory .aaa Inbox Archive/: Input/output error
> 
> ls -la .Sent\ Archive/
> total 5932871552481704068
> drwx------     6 mik        users                     4096 2009-10-02 12:36 .
> drwx------    12 mik        users                     4096 2009-10-02 12:27 ..
> cr-SrwSrwT 30768 1801873002 1496920692        1613, 231244 2027-01-27 06:53 
> courierimapkeywords
> dr-xrwSr-t 30062 1165184817  873096304 8671482274525501817 2026-01-19 19:18 
> courierimapuiddb
> drwx------     2 mik        users                     4096 2009-07-31 15:21 
> cur
> -rw-------     1 mik        users                    22528 2009-09-29 10:05 
> dovecot.index.cache
> -rw-------     1 mik        users                      896 2009-09-27 22:50 
> dovecot.index.log
> -rw-------     1 mik        users                     1126 2009-09-25 14:26 
> dovecot-uidlist
> ?--x-w-r-t 29739 1110729523  826363463 7235987552073157170 2033-05-31 16:29 
> maildirfolder
> ?r-xr---wt 22328  929450849 1399928645 4121162288830115449 1975-07-20 07:56 
> new
> drwx------     2 mik        users                     4096 2009-10-02 12:20 
> tmp
> 
> ls -la .Sent\ Archive/new
> ?r-xr---wt 22328 929450849 1399928645 4121162288830115449 1975-07-20 07:56 
> .Sent Archive/new

Grrr, my patch missed your problem? Sigh.

Didn't you see any write I/O errors before these messages?

Regards,
Ryusuke Konishi
