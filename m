From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Can't mount nilfs - error searching super root.
Date: Fri, 16 Jan 2009 02:01:15 +0900 (JST)
Message-ID: <20090116.020115.07539201.ryusuke@osrg.net>
References: <3313c4ab0901150703o5f86dc67y9261156a5519e1d5@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <3313c4ab0901150703o5f86dc67y9261156a5519e1d5-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, milosdsax-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi!
On Thu, 15 Jan 2009 16:03:07 +0100, "Milos Jana" wrote:
> I managed to apply the patch (the file fsck0.nilfs2.c was created) but
> after building nilfs-utils I can't find fsck0.nilfs2 command, it looks
> like it was not compiled.
> 
> Here is build log: http://wklej.org/id/39551/

Okay. In some environment, Makefiles are not regenerated automatically.
You may have to run automake and autoconf before running the
./configure script.  The full build procedures are as follows:

 $ tar jxf nilfs-utils-2.0.6.tar.bz2
 $ cd nilfs-utils-2.0.6
 $ patch -p1 < path-to-fsck0.patch
[ usually omissible
 $ aclocal
 $ autoheader
 $ libtoolize -c --force
 $ automake -a -c
 $ autoconf
] 
 $ ./configure
 $ make

 $ sudo make install
 $ sudo fsck0.nilfs2 <device>

If your machine doesn't have autoconf, automake, or libtool package,
these may be required in advance.

How did it come out?

Ryusuke
