From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Deadlocks! help, please!
Date: Thu, 17 Jan 2008 18:14:54 +0900
Message-ID: <1200561294.3085.131.camel@localhost.localdomain>
References: <20080116222500.60e78090@vosztok>
	<1200556717.3085.94.camel@localhost.localdomain>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1200556717.3085.94.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
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

Hi Gergely,

On Thu, 2008-01-17 at 16:58 +0900, Ryusuke Konishi wrote:
> On Wed, 2008-01-16 at 22:25 +0100, Gergely G=E1bor wrote:
> > The situations were the following:
> >=20
> > using gimp to cut a picture
> > browsing web with epiphany browser
> > epiphany again
> >=20
> > rtorrent was running in the background.
>=20
> Sorry for inconvenience.
> I will try to reproduce the problem by using same applications.
> I may ask for your help to get information if I cannot.

Oh, I cannot try rtorrent right now because we have a
restriction on use of P2P softwares :).

Could you get information through the following way
when you next encounter the hang ?

 $ su  ( or login as root )
 # echo t > /proc/sysrq-trigger

This forces the kernel to dump stack of processes into
the system log, and may give us hints for the deadlock.

Thanks in advance,
--=20
Ryusuke Konishi
NILFS team NTT
http://www.nilfs.org/
