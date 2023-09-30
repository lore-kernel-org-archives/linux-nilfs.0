From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 86/87] fs: switch timespec64 fields in inode to discrete integers
Date: Sat, 30 Sep 2023 09:50:41 -0500
Message-ID: <CAH2r5ms14hPaz=Ex2a=Dj0Hz3XxYLRKFj_rHHekznTbNJ_wABQ@mail.gmail.com>
References: <20230928110554.34758-1-jlayton@kernel.org> <20230928110554.34758-2-jlayton@kernel.org>
 <6020d6e7-b187-4abb-bf38-dc09d8bd0f6d@app.fastmail.com> <af047e4a1c6947c59d4a13d4ae221c784a5386b4.camel@kernel.org>
 <20230928171943.GK11439@frogsfrogsfrogs> <6a6f37d16b55a3003af3f3dbb7778a367f68cd8d.camel@kernel.org>
 <636661.1695969129@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696085453; x=1696690253; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=laSU2ptF5dJtGJTOfsu2vTDoKsI4bo31YwsLIpMZHsY=;
        b=MwDUKEd6QG0EtvDSCKf1uxGsuk6yCPhM15PYIYhqDJOgasuaT7+4Oh6GiJZ/vmFugy
         lmSCSLc0F+hG3ukOAM3WdNdBnEAtspfwfQIzIK1Wl+hsYj7CnlRK1SN0CwP2toV4bow4
         LCG2gYB2ozawxJ9b/KfUJbxAn6Xa7t4YEVAl9uocXX1Jw3qs6c/EXfaIr8Rz78OCo8KR
         46YxdeGs8zmcFe+Db4BddvMZE57ZBrJ3u+0YeAZwI0lUMX0nfUrsuM9wr1T+Cx+4tFCh
         43LmQPeSUyLxSTkiFSJ67LGdePIyZblA6OKDAQ/vyk5/2yD5+W+J95PEpgI6GVNdDKdn
         9Sww==
In-Reply-To: <636661.1695969129@warthog.procyon.org.uk>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: David Howells <dhowells@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, "Rafael J . Wysocki" <rafael@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Anders Larsen <al@alarsen.net>, Carlos Llamas <cmllamas@google.com>, Andrii Nakryiko <andrii@kernel.org>, Mattia Dongili <malattia@linux.it>, Hugh Dickins <hughd@google.com>, John Johansen <john.johansen@canonical.com>, Yonghong Song <yonghong.song@linux.dev>, Alexander Gordeev <agordeev@linux.ibm.com>, Christoph Hellwig <hch@lst.de>, Mike Marshall <hubcap@omnibond.com>, Paulo Alcantara <pc@manguebit.com>, linux-xfs@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, James Morris <jmorris@namei.org>, Christophe Leroy <christoph>

On Fri, Sep 29, 2023 at 3:06=E2=80=AFAM David Howells via samba-technical
<samba-technical@lists.samba.org> wrote:
>
>
> Jeff Layton <jlayton@kernel.org> wrote:
>
> > Correct. We'd lose some fidelity in currently stored timestamps, but as
> > Linus and Ted pointed out, anything below ~100ns granularity is
> > effectively just noise, as that's the floor overhead for calling into
> > the kernel. It's hard to argue that any application needs that sort of
> > timestamp resolution, at least with contemporary hardware.
>
> Albeit with the danger of making Steve French very happy;-), would it mak=
e
> sense to switch internally to Microsoft-style 64-bit timestamps with thei=
r
> 100ns granularity?

100ns granularity does seem to make sense and IIRC was used by various
DCE standards in the 90s and 2000s (not just used for SMB2/SMB3 protocol an=
d
various Windows filesystems)


--=20
Thanks,

Steve
