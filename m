From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: proper name for userspace package?
Date: Fri, 31 Jul 2009 02:32:34 +0900 (JST)
Message-ID: <20090731.023234.56054455.ryusuke@osrg.net>
References: <4A71CA72.8080106@redhat.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4A71CA72.8080106-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Daniel Baumann <daniel-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>

(Cc added to Debian maintainer)
On Thu, 30 Jul 2009 11:29:38 -0500, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> I'm wondering what the preferred name is for the userspace package.
> 
> The tarball is "nilfs-utils" but debian has "nilfs2-tools" - is there a
> preference, or is this a debian convention that caused the rename?
> 
> Thanks,
> -Eric

I don't know the how and why.  The btrfs was also packaged with the
"-tools" convention in Debian.  On the one hand, we can see all the
convensions like "-utils", "-tools", and "progs" there.

Personally, I like the "-tools" convension for new ones.

Regards,
Ryusuke Konishi
