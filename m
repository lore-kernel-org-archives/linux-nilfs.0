From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs and nfs
Date: Fri, 14 Mar 2008 17:02:22 +0900
Message-ID: <1205481742.3674.19.camel@localhost.localdomain>
References: <25256.128.221.197.20.1205268369.squirrel@webmail.cs.uml.edu>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <25256.128.221.197.20.1205268369.squirrel-2RFepEojUI2jOflrV+lkmze48wsgrGvP@public.gmane.org>
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
Content-Type: text/plain; charset="windows-1252"
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi Bill and Kallol,

On Tue, 2008-03-11 at 16:46 -0400, bill-ozn5a1fpZJs3uPMLIKxrzw@public.gmane.org wrote:
> Is there a way to export an NILFS object over NFS ?  exportfs errors wi=
th
> =93/object does not support NFS export=94 when I attempt to include an =
entry
> in /etc/exports for /object, which is an NILFS object =85 I=92ve tried =
using
> the fsid=3D option in the exports entry but this doesn=92t seem to help=
 ...
> any info would be appreciated ... Bill

and,

On Thu, 2008-03-13 at 15:52 -0400, Par_Kallol-mb1K0bWo544@public.gmane.org wrote:
> Hi=20
>=20
> I am currrently evaluating NILFS.=20
>=20
> I am having trouble (remotely) mounting a NILFS volume from an NFS
> client. I get a message from the server as "permission denied". I have
> made my mount "world rw" accessible.
>=20
> Please let me know if you can help.

Thanks you for reporting the problem!

I've tracked the problem and implemented a few features needed to support=
=20
nfs (exportfs), and pushed the patch to my git tree a little while ago.

Could you try the latest version on the git tree ?
It is available as follows,

 $ git clone http://git.nilfs.org/nilfs2-module.git
 $ cd nilfs2-module
 $ make
 $ sudo make install

It may require git-core (or git) package if not installed.=20

Best regards,
--=20
Ryusuke Konishi
NILFS team NTT
http://www.nilfs.org/
