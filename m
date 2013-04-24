From: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Performance problems solved (was: "Very low write-performance and
 troubles with RPM")
Date: Wed, 24 Apr 2013 16:22:48 +0200
Message-ID: <CAFvQSYTzB_O1C=6A+OguLHnvNHO9tt=66k38eJ1-FM1dN2fBgQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:date:message-id:subject:from:to
         :content-type;
        bh=JacMVq6sf41hVBConGoVxuZ6tz3oYpRY9tu3zLHOtpk=;
        b=l0tOoG9fSpq+KWlMlWv8JbFbnAgU59suKqf0vox4AyllinWvV1ogkDeXfVXu/ia5V2
         wuACqCf10MFoQAeRsKXkHcNGDneZvxlVVfL/SGq/bMeFPhSqvF34GLtCdTak/75qB/ux
         E4f0NpHv6tt6Kk/RjFrGBCTJBtU3nPj0v28jotmYIZa8khlS+lt1heWxjOhQg6X62yPH
         f+TyVvIjzBgD2FCSkqMIrGYu44LF7jdvx4LlM/6XBcoaMU8sdpxWjgWwpdurq6bqNSST
         qMEVTDCurE+4UCctLPelszfE/nzLH1ciIlV32ZUEjU3IuIvlLYVRwxXc1TG/paYdGKQv
         OlXQ==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi again,

I was able to trace the performance issues down to the "slub_debug"
kernel option which is set in fedora test builds.
With this option disabled performance is not great, but not that bad
either (~110mb/s on an SSD which usually does 400mb/s sequential).

Thanks a lot for nilfs, hopefully it will reduce my suffering after
accidential command line desasters ;)

Thanks, Clemens
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
