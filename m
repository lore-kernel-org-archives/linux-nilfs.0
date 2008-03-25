From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Nilfs 2.0.1 fails to mount a nilfs-2.0.0 filesystem
Date: Tue, 25 Mar 2008 16:23:04 +0900
Message-ID: <1206429784.3131.39.camel@localhost.localdomain>
References: <20080324125404.f299fbe2.nilfs@blinkenlights.ch>
	<1206360729.7809.5.camel@localhost.localdomain>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1206360729.7809.5.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
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

Hi Adrian,

On Mon, 2008-03-24 at 21:12 +0900, Ryusuke Konishi wrote:
> Hi,
>=20
> On Mon, 2008-03-24 at 12:54 +0100, Adrian Ulrich wrote:
> > Hi,
> >=20
> > I've just upgraded from nilfs 2.0.0 to 2.0.1 (kernel + userland) and =
noticed
> > that nilfs 2.0.1 fails to mount my 2.0.0 filesystem:
> >=20
> > > NILFS: Invalid checkpoint (checkpoint number=3D12178)
> > > NILFS: error loading a checkpoint (checkpoint number=3D12178).
> >=20
> > Mounting the filesystem with nilfs-2.0.0 works just fine.
> >=20
> > Is this a bug or did the disk-format change in 2.0.1 ?
>=20
> It seems to be an unintended regression.
> Please wait until further notice.  I'll look into the problem.

I've identified the bug and made a patch a little while ago.
It was an elementary but critical bug, so I appreciate very much
for your quick report.

=EF=BB=BFWe will soon release v2.0.2 to clean things up.
(Meanwhile, the corrected version is available on the git tree
 http://www.nilfs.org/git/ )


Sincerely,
--=20
Ryusuke Konishi
NILFS team NTT
http://www.nilfs.org/
