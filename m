From: Zavi <zavi05-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Initial mount fails
Date: Sun, 4 Dec 2011 11:10:12 +0200
Message-ID: <CAN67vW1TR8g=LBH6p+G4yj8UL9wCmjLghGJJOB3zzQjD-tC-Ug@mail.gmail.com>
Reply-To: zavi05-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:sender:from:date:x-google-sender-auth
         :message-id:subject:to:content-type;
        bh=4/43XAxbg9LbH5Q8NqDAXvKiD+Zz4D/iE1k4AAmwqVQ=;
        b=J6MH37VvmTpf/LmzuM0FOYRyqY6ed0jNlOa1e/uEERpsskIzXxq7me/HKeE5DWQfdf
         v9mcAqy6bqdtq0C7xOBPazgPaVip3J4qcKTtkwHa1/OZtlhJiyeelUiQnTUV2dEm9BIV
         keVsBKYScHTaIcszIeh2GZA1MAl2D7UKhr1Rk=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi all,

I'm trying yo mount nilfs on a device without success.
mkfs works just fine, but when I try to mount I keep getting an error
> sudo mkfs -t nilfs2 /dev/sdc
> sudo mount -t nilfs2 /dev/sdc ~/nilfs
mount.nilfs2: Error while mounting /dev/sdc on ~/nilfs: Invalid argument

I've installed nilfs-utils, and this is what I get from fsck
> sudo fsck0.nilfs2 -f -v /dev/sdc
fsck0.nilfs2: cannot read super block (device=/dev/sdc)

just to be sure the problem is not in the device, I mounted ext4 on it
successfuly.
I can also do block requests (dd, iometer) without a problem.

I'd appreciate any suggestion.

Thanks,
Zavi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
