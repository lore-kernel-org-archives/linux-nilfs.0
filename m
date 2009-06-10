From: nezmer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: Re: New to NILFS2
Date: Wed, 10 Jun 2009 23:44:20 +0300
Message-ID: <20090610204420.GA16338@nezmer.homelinux.org>
References: <op.uvbisbbobbxqew@sicuro>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

On Wed, Jun 10, 2009 at 01:58:49PM -0300, Nelson Sicuro wrote:
> Hi everyone
> =

> I started using NILFS2 version 2.0.14 this month on Ubuntu 8.04 and 8.10  =

> distros (2.6.24-24-generic 64 bits), so far so good.
> =

> I looked at the new's archives and find some interesting questions about  =

> deleting more than one CP at a time. Can I use this feature on my distro  =

> or do I need to recompile nilfs-tools? May this feature be included on  =

> Ubuntu 9.04?
> =

> Best regards and congrats for the excellent job!
> =

> Nelson Sicuro, from Brazil, Universidade Federal do Paran=E1
> =

> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
If you don't want to recompile , Just use seq with xargs :
#seq <start> <end> | xargs rmcp

Or If you don't want to type a lot : (untested)
function rmcpg {
seq $1 $2 | xargs rmcp
}

There's probably a better way If I actually knew how to script.
