From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: users Digest, Vol 27, Issue 3
Date: Fri, 04 Jul 2008 19:04:48 +0900 (JST)
Message-ID: <20080704.190448.56351691.ryusuke@osrg.net>
References: <mailman.1.1214535602.30509.users@nilfs.org>
	<60424.87.251.152.38.1214546611.squirrel@mail.teratelecom.ru>
	<20080627.172728.108412355.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080627.172728.108412355.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

Dear Volkov,

On Fri, 27 Jun 2008 17:27:28 +0900 (JST), Ryusuke Konishi wrote:
> On Fri, 27 Jun 2008 10:03:31 +0400 (MSD), Oleg Volkov wrote:
> > > What kind of message was printed in the problem,
> > > or did it hang up ?
> > 
> > # mount -f /
> > /sbin/mount.nilfs2: invalid option -- f
> > 
> > 
> > mount -o remount,ro /
> > mount -o remount,rw /
> > It's my mistake.
> > I did not correctly /etc/fstab
> > 
> > ---
> > Oleg Volkov
> 
> I realized that the recent mount program passes this option
> to helper mount programs, but the current mount.nilfs2
> does not support it.
> OK, I will add the option to mount.nilfs2 later.

I've uploaded mount.nilfs2 with the -f option on the nilfs2-utils
git tree.
It seems to work so far, but I haven't tested it for a root
partition.

Could you please try it to confirm everything works out?

The latest nilfs2-utils is obtainable by 

 $ git clone http://git.nilfs.org/nilfs2-utils.git

and can build as follows,

 $ cd nilfs2-utils
 $ aclocal && autoheader && libtoolize -c --force
 $ automake -a -c
 $ autoconf
 $ ./configure
 $ make
 ( this may require some packages: git-core, libtool,
   autoconf, automake, and so forth )

Thanks in advance,
Ryusuke Konishi
