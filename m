From: Dave <dave-/hCUnnzDXf0AvxtiuMwx3w@public.gmane.org>
Subject: Re: New to NILFS2
Date: Wed, 10 Jun 2009 22:28:18 +0400
Message-ID: <4A2FFB42.3090304@0bits.com>
References: <op.uvbisbbobbxqew@sicuro>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <op.uvbisbbobbxqew@sicuro>
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

Nelson Sicuro wrote:
> Hi everyone
>
> I started using NILFS2 version 2.0.14 this month on Ubuntu 8.04 and 8.10
> distros (2.6.24-24-generic 64 bits), so far so good.
>
> I looked at the new's archives and find some interesting questions about
> deleting more than one CP at a time. Can I use this feature on my distro
> or do I need to recompile nilfs-tools? May this feature be included on
> Ubuntu 9.04?

I don't belive this is in Jaunty yet since this only recently went in in 
Ryusuke-san's git tree. So yes, you would have to recompile this 
yourself (easily done). Beware however that deleting the checpoints are 
only cosmetic at the moment (i.e. you won't see them in a 'lscp' output) 
and you still need to wait for the cleanerd to reclaim space.

D
