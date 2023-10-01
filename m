From: Gabriel Paubert <paubert@iram.es>
Subject: [OT] Re: [PATCH 86/87] fs: switch timespec64 fields in inode to
 discrete integers
Date: Sun, 1 Oct 2023 07:01:56 +0200
Message-ID: <20231001050156.GA3366643@gp-workstation.iram.es>
References: <20230928110554.34758-1-jlayton@kernel.org>
 <20230928110554.34758-2-jlayton@kernel.org>
 <6020d6e7-b187-4abb-bf38-dc09d8bd0f6d@app.fastmail.com>
 <af047e4a1c6947c59d4a13d4ae221c784a5386b4.camel@kernel.org>
 <20230928171943.GK11439@frogsfrogsfrogs>
 <6a6f37d16b55a3003af3f3dbb7778a367f68cd8d.camel@kernel.org>
 <636661.1695969129@warthog.procyon.org.uk>
 <CAH2r5ms14hPaz=Ex2a=Dj0Hz3XxYLRKFj_rHHekznTbNJ_wABQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iram.es; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to:content-transfer-encoding; s=dkim3;
         bh=5JgHwkJ5bZA+PRufvniyMuRJN1Jr6719sKCuadOAMmw=; b=hDNmwqgug1An
        fvwB2cRTfoutFDu+tai+5nrTyDJGpD0Pkv+UoD9dDHnHHIAd09gz+r02mse1Cs9K
        ZCgOca/WGL5QjFanXXswWHZ9gsDFv9HUsGVbSl0NWG9zgx7F1IrS1vcyAC4I2TBu
        vtCiSXblwT2BOKB168GcAoNAG3zywK5ZIdX9TFP4bHS8GBFExgd9NXibijGF4eid
        NlYGioPXJRFaYlb2eKu0casy5f5iNW/FoS1c0RbxZP9tWhnpwN4+plV0Uq3PyrZu
        vjfbiPtJ7zPzKAVMjvhFWJMgaNJzLRSZANzAdWFrm7A8N1ie1vidQt1Dp6QldrsP
        8q3fZB20SA==
Content-Disposition: inline
In-Reply-To: <CAH2r5ms14hPaz=Ex2a=Dj0Hz3XxYLRKFj_rHHekznTbNJ_wABQ@mail.gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Steve French <smfrench@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Latchesar Ionkov <lucho@ionkov.net>, "Rafael J . Wysocki" <rafael@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Anders Larsen <al@alarsen.net>, Carlos Llamas <cmllamas@google.com>, Sven Schnelle <svens@linux.ibm.com>, Mattia Dongili <malattia@linux.it>, Yonghong Song <yonghong.song@linux.dev>, Alexander Gordeev <agordeev@linux.ibm.com>, Christoph Hellwig <hch@lst.de>, Mike Marshall <hubcap@omnibond.com>, Paulo Alcantara <pc@manguebit.com>, Jason Gunthorpe <jgg@ziepe.ca>, James Morris <jmorris@namei.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, devel@lists.orangefs.org, Shyam Prasad N <sprasad@microsoft.com>, Jan Harkes <jaharkes@cs.cmu.edu>, linux-um@lists.infradead.org, Nicholas Piggin <n>

On Sat, Sep 30, 2023 at 09:50:41AM -0500, Steve French wrote:
> On Fri, Sep 29, 2023 at 3:06=E2=80=AFAM David Howells via samba-technic=
al
> <samba-technical@lists.samba.org> wrote:
> >
> >
> > Jeff Layton <jlayton@kernel.org> wrote:
> >
> > > Correct. We'd lose some fidelity in currently stored timestamps, bu=
t as
> > > Linus and Ted pointed out, anything below ~100ns granularity is
> > > effectively just noise, as that's the floor overhead for calling in=
to
> > > the kernel. It's hard to argue that any application needs that sort=
 of
> > > timestamp resolution, at least with contemporary hardware.
> >
> > Albeit with the danger of making Steve French very happy;-), would it=
 make
> > sense to switch internally to Microsoft-style 64-bit timestamps with =
their
> > 100ns granularity?
>=20
> 100ns granularity does seem to make sense and IIRC was used by various
> DCE standards in the 90s and 2000s (not just used for SMB2/SMB3 protoco=
l and
> various Windows filesystems)

Historically it probably comes from VMS, where system time and file
timestamps were a 64 bit integer counting in 100ns units starting on MJD
2400000.5 (Nov 17th 1858).

Gabriel

>=20
>=20
> --=20
> Thanks,
>=20
> Steve
 

