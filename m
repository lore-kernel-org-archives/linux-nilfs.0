From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: NILFS utils 2.0.3 release
Date: Thu, 22 May 2008 21:04:04 +0900
Message-ID: <1211457844.3607.155.camel@localhost.localdomain>
References: <1211333645.3116.8.camel@localhost.localdomain>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1211333645.3116.8.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
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
Content-Type: text/plain; charset="utf-8"
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Dear NILFS users,

=EF=BB=BFOn Wed, 2008-05-21 at 10:34 +0900, Ryusuke Konishi wrote:
> Dear NILFS users,
>=20
> =EF=BB=BFWe have released nilfs-utils-2.0.2,
> which added man pages for every command.

The previously released utility package had a problem
that it may cause lack of man pages when a user try to
make a distribution package =EF=BB=BFthrough performing,
for example, 'make dist-bzip2'.

To avoid confusion, we will release nilfs-utils-2.0.3
that fixes the problem.

This release is equivalent to the previous release
for the rest.
So, you don't have to replace the recent utilities
if the man pages are properly installed.
(try `man nilfs' for example)

Thanks,
--=20
Ryusuke Konishi
NILFS team NTT
http://www.nilfs.org/
