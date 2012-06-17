From: Tim Bannister <Tim.Bannister-m7QheJJv02N4oUbgFh0ZNQ@public.gmane.org>
Subject: RE: NILFS2 under stress
Date: Sun, 17 Jun 2012 15:07:43 +0000
Message-ID: <985C1135657081458B80476678A9AF7F3ADDACF0@MBXP05.ds.man.ac.uk>
References: <20120615165024.GI16953@csmith-bm.vm.bytemark.co.uk>
 <985C1135657081458B80476678A9AF7F3ADDAC29@MBXP05.ds.man.ac.uk>,<20120616190906.GJ16953@csmith-bm.vm.bytemark.co.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120616190906.GJ16953-Ng8wz+J301SNY5Lh21HnMTHS2PGA244I9dF7HbQ/qKg@public.gmane.org>
Content-Language: en-GB
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

> On Sat, Jun 16, 2012 at 11:49:55AM +0000, Tim Bannister wrote:
> > > In summary, I think NILFS is fantastic in short bursts of heavy p=
ressure
> > > so long as space isn't exhausted.
>
> > OK, but if exhausting the space leads to unrecoverable / difficult-=
to-fix=20
> > data loss then it's a poor choice of filesystem for uses where a fu=
ll=20
> > filesystem is unlikely but remains a possibility (eg a mail spool).=
 If=20
> > /var/tmp shouldn't be on NILFS then probably /var shouldn't be on N=
ILFS=20
> > either.
=85
> Perhaps one area where NILFS could be improved is in handling of disk=
 full
> errors, for example, not allowing complete exhaustion of space unless=
 a
> cleaner is running.

Lots of filesystems reserve a certain amount of space for root. I would=
 extend=20
this for NILFS2 to reserve some space for the cleaner daemon (perhaps w=
ith=20
an ioctl that can be used by the daemon to bypass the restriction).

Easier said than coded ;-)

--=20
Tim Bannister
IT Services
The University of Manchester

e: Tim.Bannister-m7QheJJv02N4oUbgFh0ZNeyAPIwwu4QO@public.gmane.org
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
