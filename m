From: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: nilfs-utils in Fedora now
Date: Wed, 05 Aug 2009 10:28:59 -0500
Message-ID: <4A79A53B.2090201@redhat.com>
References: <4A722B66.7010006@redhat.com>	<20090804.025321.12536090.ryusuke@osrg.net>	<4A772687.4040704@redhat.com>
	<lu7hxicmsm.wl%kihara@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <lu7hxicmsm.wl%kihara-sG5X7nlA6pw@public.gmane.org>
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

Seiji Kihara wrote:
> Hello,
> 
> Thank you for your effort to support nilfs in Fedora!
> 
> At Mon, 03 Aug 2009 13:03:51 -0500,
> Eric Sandeen wrote:
>> Do you mean like a kmod rpm for updated nilfs kernel code that is not
>> yet upstream?  No, Fedora doesn't allow kmods in the official
>> repositories.  But nilfs is already configured on in F11 and F12, so
>> nilfs.ko is already there in the kernel rpm.
> 
> Is nilfs already configured on in Fedora 11?  I tried to use
> the kernel package in updates-testing repo, but nilfs2.ko is
> not contained in the package.  The package seems to be based
> on kernel-2.6.29 which does not include nilfs2.
> 
> Are there any repositories with kernel package for F11 which
> supports nilfs?

Ah, sorry.  The pending 2.6.30 update for F11 should have it, I forgot
that wasn't done yet.

Thanks,
-Eric
