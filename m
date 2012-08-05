From: Paolo Giangrandi <paolo-UnihLHphgvQ1GQ1Ptb7lUw@public.gmane.org>
Subject: nilfs2 not garbage collecting
Date: Sun, 5 Aug 2012 13:00:02 +0200
Message-ID: <CANku=ghnDzkFHpPZ8eT9Y3kTM62zBKMk6TjBVraE4Kisa1TRPQ@mail.gmail.com>
References: <CANku=ggohcWWoxE1x=XmfWpANKyWRTWb5p_aHh8LU6+utU4OPQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type;
        bh=IvJXjDuFx4oV2fACtfqMA+TCIDHSO9g7Hicrhu8+Jcg=;
        b=yT1EyoE0A/7yQJDUJq/uU4z67jBps33JpGwax8zneigS3eiXpT4H7XRgyl/1bqQ56f
         G/HDcYfPlqsg420xJzjIfXf7wwMMzgWx4PUdsD0qClzNbZjNJzRPLwaP/MUH8RBjvLDY
         T31/0QvxHfAlqwL+XB/2UUu6Dzn3QGvbKthHsqZcyCQtv1qOmzFllKNkxaW2+qy2rzQj
         wPVr5nGZC6dIjyjw/ToenA6MxZh631JwXvw9i67CcOGFxXMi78vtbSuo0Dac63mRVqb9
         mJy+8hu65+kG6ObIfjTAWAoK+S/ySWegzBKDeVHEn/F7a+q/ii+Gmb7wTyK40paQM2su
         oRYw==
In-Reply-To: <CANku=ggohcWWoxE1x=XmfWpANKyWRTWb5p_aHh8LU6+utU4OPQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

I'm using NILFS2 as the root filesystem of an ArchLinux on my EeePC
900A. The filesystem has been created last November.
At the moment there's no more space left, `lscp` shows that there are
2648 checkpoints, but nilfs_cleanerd is in idle.
I tried to tweak nilfs_cleanerd configuration, but couldn't achieve anything.

Is it possible to know why nilfs_cleanerd isn't collecting the
checkpoints, or force it to collect them?

Thanks,
Paolo
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
