From: Assaf Weizman <assaf.weizman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Super Root Block
Date: Mon, 8 Mar 2010 15:22:44 +0200
Message-ID: <63c84f241003080522r29550410tcd954ac69003b2a3@mail.gmail.com>
References: <63c84f241003080059v5f147ecas5b8df9ebc2d154aa@mail.gmail.com> 
	<20100308.190841.192724574.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:in-reply-to:references
         :from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        bh=i4CjAVbycaHx8csmtQ+BVMFa2SoCotO8E+GCVrm9yP4=;
        b=EwJutAY7gJu+XjY9sgxDCzAgXPPya2coIlFmUU81PPT4l9SPpgaQEZN6ejokjiFdY/
         LjVDX55n1N8Oc0f3uu2O0mL03mIiPLQVTPdS1uqofdNxoLseQ/sXsbskVys7SQCYAYl1
         kqcRd6N+zD7y/lxevjXHTvZMVu7MrrmUVhivA=
In-Reply-To: <20100308.190841.192724574.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Thank you very much! Mr. Konishi.

Best wishes
Assaf Weizman

On Mon, Mar 8, 2010 at 12:08 PM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wro=
te:
>
> Hi,
> On Mon, 8 Mar 2010 10:59:44 +0200, Assaf Weizman wrote:
> > Hello,
> > Could you please explain a few theoretical questions:
> > a. What's the meaning/usage of the "Super Root Block"?
> > b. in the Readme (v2) file it's described as "an optional super roo=
t
> > block (SR)". So as optional element, =A0who chooses to whether to
> > activate\use it or not?
>
> The super root block contains inodes of checkpoint file (cpfile),
> segment usage file (sufile), and disk address translation (DAT) file.
>
> It represents the top of metadata hierarchy of NILFS at a time point.
> For the metadata hierarchy, please see the page 9 of the slides:
>
> =A0http://www.nilfs.org/papers/jls2009-nilfs.pdf
>
>
> I think the term "optional" in the readme looks confusing.
>
> In nilfs, if a series of logs makes a new checkpoint, it essentially
> ends with a super root block. =A0Otherwise, it does not entail the su=
per
> root block (there is a variant of log series used for synchronous dat=
a
> write).
>
> > Thanks a lot. this is a very interesting file system.
> >
> > Best regards
> > Assaf Weizman
>
> Thank you. =A0I think the above slides would be helpful than the read=
me
> file.
>
> With regards,
> Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
