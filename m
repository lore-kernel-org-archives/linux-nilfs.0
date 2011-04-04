From: Alessandro Salvatori <sandr8-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs_cleanerd could use some sensible defaults if its conf file
 is empty...
Date: Mon, 4 Apr 2011 11:16:51 -0700
Message-ID: <BANLkTim5VFXM8tQpH_-8vAVaZ-z5asiZdA@mail.gmail.com>
References: <BANLkTi=r2nmV1B9nF=f23fk2YxDch0ewRQ@mail.gmail.com> <20110404.190037.212385465.ryusuke@osrg.net>
Reply-To: sandr8-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        bh=2YcZNFu7Qkxsw5+h9GoIZENumYExEh7hYvNjEFBAlD0=;
        b=xBMm8/nz5BFIjgcnAIVXdaR2mcDhwlMBXrcFtx7ijYuJkJ75mXXyjEHf7RO1aAU4Is
         ufMvOcs+iafvFuIYmUUh3oTLeNQJvko7buQM4498PZBochpmBggZE2hnIwxC0UardRTh
         AK7gh/08+QtQPsTioVRJC7W4gvDSrAqYNS/wQ=
In-Reply-To: <20110404.190037.212385465.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

of course i had already tried -p 0 and also -p 1, in case 0 had some
special meaning ^_^

thank you!
-alessandro-
=A0Here i am, A young man,
=A0A crashing computer program,
=A0Here is a pen, write out my name.

On Mon, Apr 4, 2011 at 03:00, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> On Sun, 3 Apr 2011 13:49:47 -0700, Alessandro Salvatori wrote:
>> Hello,
>>
>> =A0 =A0 my root nilfs2 filesystem filled and trying and editing
>> /etc/nilfs_cleanerd.conf resulted in an empty file.
>>
>> I started the cleanerd but it wasn't freeing up any space.
>> Then I converted all of my snapshots back onto checkpoints and remov=
ed
>> all of my checkpoints.
>>
>> still nothing.
>
> Did you try '-p' option?
>
> nilfs_cleanerd tries to protect recent checkpoints within the period
> specified with "protection_period" parameter.
>
> It is set to one hour by default. =A0So, the effect of converting
> snapshots back to checkpoints will not appear soon.
>
> But, you can shorten this period by using the '-p' option for
> emergency.
>
>> Then I created a new nilfs_cleanerd.conf with sensible values in my
>> home directory and pointed nilfs_cleanerd to that.
>>
>> and finally it worked!!!
>>
>> maybe nilfs_cleanerd could default to some minimum of -say- the leas=
t
>> between some small amount of gigabytes and some small percentage of
>> the disk size as the minimum space to free if no setting is found in
>> the configuration file?
>
> The current nilfs_cleanerd.conf has keyword 'min_clean_segments' to
> specify percentage of minimum free space, but the effect of
> protection_period is prior to that.
>
> So, adding another parameter sounds worth considering as you pointed
> out.
>
> For instance,
>
> =A0emerg_clean_segments =A0 =A0 5% =A0 =A0# override protection_perio=
d
> =A0min_clean_segments =A0 =A0 =A010%
> =A0max_clean_segments =A0 =A0 =A020%
>
> Am I on the right track?
>
> Thanks,
> Ryusuke Konishi
>
>> thank you!
>> -alessandro-
>> =A0Here i am, A young man,
>> =A0A crashing computer program,
>> =A0Here is a pen, write out my name.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilf=
s" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
