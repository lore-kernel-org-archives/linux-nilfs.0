From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: NILFS2 get stuck after bio_alloc() fail
Date: Tue, 23 Jun 2009 13:40:26 +0900 (JST)
Message-ID: <20090623.134026.08265083.ryusuke@osrg.net>
References: <20090614153256.GA4020@homero.springfield.home>
	<20090615.030245.104791670.konishi.ryusuke@gmail.com>
	<20090614181313.GA16597@homero.springfield.home>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090614181313.GA16597-ukiYB341y+1jWMeXa1+QZ5bDTtF7IOEM@public.gmane.org>
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
To: llucax-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: albertito-vOTlzuNH1/1M3YmQoIpPTg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi Leandro,
On Sun, 14 Jun 2009 15:13:13 -0300, Leandro Lucarella <llucax-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Ryusuke Konishi, el 15 de junio a las 03:02 me escribiste:
> [snip]
> > > Here is the complete trace:
> > > http://pastebin.lugmen.org.ar/4931
> > 
> > Thank you for your help.
> > 
> > According to your log, there seems to be a leakage in clear processing
> > of the writeback flag on pages.  I will review the error path of log
> > writer to narrow down the cause.
> 
> Oh! I forgot to tell you that the cleanerd process was not running. When
> I mounted the NILFS2 filesystem the cleanerd daemon said:
> 
> nilfs_cleanerd[29534]: start
> nilfs_cleanerd[29534]: cannot create cleanerd on /dev/loop0
> nilfs_cleanerd[29534]: shutdown
> 
> I thought I might have an old utilities version and that could be because
> of that (since the nilfs website was down I couldn't check), but now
> I checked in the backup nilfs website that latest version is 2.0.12 and
> I have that (Debian package), so I don't know why the cleanerd failed to
> start in the first place.

At the last weekend, several users gave me feedback on the same early
failure of cleanerd process.

This problem turned out to be caused by an elementaly bug in the
userland library of nilfs; there was a lack of canonicalization of
pathname in the library, and it caused the failure, for example, when
user adds an extra slash symbol to the mount directory name.

We have released nilfs2-utils-2.0.13 yesterday to resolve this mess.
If you didn't know it, please try the updated package.

Thanks,
Ryusuke Konishi
