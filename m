From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Deadlocks! help, please!
Date: Fri, 18 Jan 2008 12:58:12 +0900
Message-ID: <1200628693.2931.54.camel@localhost.localdomain>
References: <20080116222500.60e78090@vosztok>
	<1200556717.3085.94.camel@localhost.localdomain>
	<1200561294.3085.131.camel@localhost.localdomain>
	<20080117183302.275d051d@vosztok>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080117183302.275d051d@vosztok>
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
Content-Type: text/plain; charset="iso-8859-1"
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

On Thu, 2008-01-17 at 18:33 +0100, Gergely G=E1bor wrote:
> On Thu, 17 Jan 2008 18:14:54 +0900
> Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
>=20
> > Hi Gergely,
>=20
> Hello Ryusuke! (i hope i guessed well, actually my firstname is G=E1bor=
,
> as we write names in reverse order to english speaker world, yet i don'=
t
> know the Japaneese customs)

Hi G=E1bor :),
# We write first name first to english speaker world, though we usually
# first write family name and then write "first name" in Japanese.
# So my first name is Ryusuke.=20

> > Oh, I cannot try rtorrent right now because we have a
> > restriction on use of P2P softwares :).
> >=20
> fortunately i can,and rtorrent (or something else) faithfully
> reproduces the lock. :)

I tried rtorrent last night, but I couldn't reproduce it on my NILFSized
notebook.
Could you tell me about the rtorrent workload that you burdened ?
I tried to download 4~8 Debian CD iso-s concurrently for 2~3 hours
using gimp and web browsers.  But it didn't reproduce hang.

> > Could you get information through the following way
>=20
> I attach the kernel log. Sorry for the long delay, but the machine froo=
ze
> during kernel recompilation, as i didn't use sysrq before. It worked.
> Hope the information will be useful.
Great!

I will look into both logs.

Anyway, thanks a lot for your effort.

--=20
Ryusuke Konishi
NILFS team NTT
http://www.nilfs.org/
