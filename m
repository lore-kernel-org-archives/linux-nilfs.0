From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: proper name for userspace package?
Date: Tue, 04 Aug 2009 04:10:06 +0900 (JST)
Message-ID: <20090804.041006.12536354.ryusuke@osrg.net>
References: <4A71CA72.8080106@redhat.com>
	<20090731.023234.56054455.ryusuke@osrg.net>
	<4A71E82C.1040208@debian.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4A71E82C.1040208-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
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
To: daniel-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org
Cc: sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

On Thu, 30 Jul 2009 20:36:28 +0200, Daniel Baumann wrote:
> Ryusuke Konishi wrote:
> >> The tarball is "nilfs-utils" but debian has "nilfs2-tools" - is there a
> >> preference, or is this a debian convention that caused the rename?
> 
> it's my own aim to get some sort of uniformity with package names in
> debian, so that we have $filesystem-tools for new packages. new means
> basically almost anything after e2fsutils.

Thanks.  I felt this implicitly, and now I get it straight from you.
 
> actually, i should rename it from nilfs2-tools to nilfs-tools.
> unfortunately, in debian we have a quite stupid thing called NEW queue
> which make such a simple rename have a penalty of 4 to 8 weeks of
> waiting until ftp-masters unblock it. but i still might do that at some
> point (unless Ryusuke dislikes it ;).

Well, I don't mind either.  I'm accountable for part of the confusion
especially for the version number ;)

"nilfs-tools" sounds simpler. Umm, actually it would be better in the
long term because the nilfs package already has versions related to
the filesystem version (e.g. -2.x.y).  At least I don't have any
reason to object to the rename.

I just realized that ocfs2-tools package has versions 1.x.y.


Thanks,
Ryusuke Konishi
