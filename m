From: "Jason J. W. Williams" <jasonjwwilliams-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Re-capturing space
Date: Wed, 10 Nov 2010 18:36:15 -0700
Message-ID: <AANLkTimOf0eTokRpvd2gG=nSTsfmRZnTpX5+tepetpUz@mail.gmail.com>
References: <AANLkTi=6k2_v4Ga+4V8EQEsGQ5oNTn_wnc=bbdB94k27@mail.gmail.com>
	<AANLkTi=+FiC=y2jpV-rJmgxdsMEdVBkk9E2_3SZGed3L@mail.gmail.com>
	<20101111.100359.179929646.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:received:in-reply-to
         :references:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        bh=yILgfGXdeit5ueo+SjEEyVQm+lERLHXm8yLVEautLhc=;
        b=S5eU7mKW2KREg7ZRsx+cCF/YbWB1Lit3YgdlfA9YPcFEgGla1LtqrNy5CwfoRcdEqp
         H7NDaf2dqYLFbGZFPI73FVPz3uKgWXEicTGSwXzDSHwQ6efk6TfuUH3uvl2UbSfha6N7
         tfmmQWcu41KDLMlH5EVpLNnzCfhkQC7+AoOEQ=
In-Reply-To: <20101111.100359.179929646.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Ryusuke,

Thank you very much for you answer! Does anyone run MySQL on NILFS or
is the random nature of database access poorly suited to good
performance on NILFS?

-J

On Wed, Nov 10, 2010 at 6:03 PM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wro=
te:
> Hi,
> On Wed, 10 Nov 2010 12:10:25 -0700, "Jason J. W. Williams" wrote:
>> Hello,
>> I'm looking at NILFS as a possible alternative to BTRFS for our move
>> off of ZFS. Looking at the description of how NILFS works, it seems
>> like it's one big log. New records go on the front. My question is h=
ow
>> does space eventually get recaptured when you delete files? Does the
>> log get rewritten/compacted regularly?
>>
>> -J
>
> Yes, a garbage collector daemon does that. =A0It copies "live" blocks=
 to
> the tail from the head of the log, and then frees some obsolete
> segments from the log head.
>
> Try "lssu" command to see how it works.
>
> By default, the garbage collector (nilfs_clearned) will start when th=
e
> amount of free space falls below 10% of the disk space.
>
> You can change it by modifying /etc/nilfs_cleanered.conf.
>
> Regards,
> Ryusuke Konishi
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
