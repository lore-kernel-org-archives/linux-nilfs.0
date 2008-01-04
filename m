From: amagai-sG5X7nlA6pw@public.gmane.org
Subject: Re: __udivdi3
Date: Fri,  4 Jan 2008 10:47:21 +0900 (JST)
Message-ID: <20080104014721.3D7163E06C1@fs.osrg.net>
References: <20080103034154.bf6c74be.elentirmo.gilgalad@gmail.com>
	<200801032238.44785.chris@csamuel.org>
	<20080103161729.c623ad3e.elentirmo.gilgalad@gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-reply-to: <20080103161729.c623ad3e.elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> (message
	from Gergely =?UTF-8?B?R8OhYm9y?= on Thu, 3 Jan 2008 16:17:29 +0100)
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,

Could you try following steps?
================
cd nilfs-2.0.0-testing-8/fs
edit Makefile, uncomment this line to enable debug option.

#CONFIG_NILFS_DEBUG=y

make clean
make

egrep -i udivdi *.lst
================
I hope that the egrep shows filename which includes the
undefined symbols.

Should the final 2.0 nilfs be released, will it be ready for use for 
example on a /home partition in real life, or will that still be
considered risky

My colleagues (and include me) are used nilfs 2 as /home 
of developping PC's with onw risk :-)
Nilfs 2 cannot handle a disk full condition well, 
so, parameter tuning in /etc/nilfs_cleanerd.conf are very critical.

Thank you.

Amagai Yoshiji
amagai-sG5X7nlA6pw@public.gmane.org
