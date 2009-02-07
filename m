From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: cleanerd segfault
Date: Sat, 07 Feb 2009 20:38:08 +0900 (JST)
Message-ID: <20090207.203808.94866640.ryusuke@osrg.net>
References: <lB4DD31fNVpx.grrKfnNr@mail.prnet.org>
	<20090205.181904.55833415.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090205.181904.55833415.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org

Hi David,
On Thu, 05 Feb 2009 18:19:04 +0900 (JST), Ryusuke Konishi wrote:
> On Thu,  5 Feb 2009 08:52:32 +0100, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org wrote:
> > I can confirm that it is also reproducable on a newly created nilfs2
> > populated with some files.
> 
> All right.
> Could you try the following patch against nilfs2-utils ?
> 
> This makes cleanerd which can dump backtrace to /var/log/segv_xxx.
> 
> To enable the feature, you need gdb and a 'backtrace' script
> available on http://samba.org/ftp/unpacked/junkcode/segv_handler/
> 
> 
> Regards,
> Ryusuke

I've pushed out updates that would fix this problem.
(Both nilfs-utils and nilfs2-modules were updated).

It turned out to be a regression brought by one of the recent bug
fixes.  It was lucky that this was found before the next release.

David, thank you for your many feedbacks.

Regards,
Ryusuke Konishi
