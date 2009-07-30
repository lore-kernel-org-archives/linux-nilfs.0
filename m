From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: remove chown from makefiles too?
Date: Fri, 31 Jul 2009 00:53:17 +0900 (JST)
Message-ID: <20090731.005317.12928769.ryusuke@osrg.net>
References: <4A71B53D.7070205@redhat.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4A71B53D.7070205-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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

Hi,
On Thu, 30 Jul 2009 09:59:09 -0500, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Hi, after the setuid bits got removed from the make install process,
> this sort of thing is still left in several Makefiles:
> 
> install-exec-hook:
> 	list='$(sbin_PROGRAMS)'; \
> 	for p in $$list; do \
> 		chown root $(DESTDIR)$(sbindir)/$$p$(EXEEXT); \
> 	done
> 
> But this fails for a normal user installing into a chroot, as an
> rpmbuild by a non-root user might do.
> 
> I don't think there's any reason for the chown; can this just be removed?

Well, I see.

I will once remove the chown and normalize it unless the removal makes
inconvenience to someone.

Thank you for the comment.

Ryusuke Konishi
