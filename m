From: Kenneth Langga <klangga-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Another question on nilfs_cleanerd
Date: Sat, 10 Mar 2012 00:15:28 +0800
Message-ID: <CAHmELnVsrSUSkJeJJX8p9h2+47MGWdLLiepXBYrEbJtvTEBpEQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:from:date:message-id:subject:to:content-type;
        bh=iI4XFzNt/9FoY0H8Ut4PvMNK7hFzx5LPIg77Se2PXRI=;
        b=N6GBwk+B7cN9oLXN67vHc51utndtavKTPbZa1zWMRU0XpxNiXf7KQJStvt5I7q2R2D
         Ey7JHX/lXx6reLHdstv6c3lZJv7pFKxbmgkIVlD6ctbUrkbUbF3uLwIB54PYJvUBwKDk
         HNuBr/ryoKCU/dMe6ADZVv0kXHZ5zCz2m2QNqRKounH9pPzaDmsnb6LdKmH0cMBULd1N
         Gf3ZmfTu+2RxJqpTKBKq58+KbcdraCW0K/PBFJqyeQ7Z0j6CRB/bwWHOyKsODfxWmM5E
         R4VwdjTrYogE0BlfqPCdN+7iRXGyX9LxZK4eQRwpO4sdz6KSU1yDSDi7cMzURVCSsT93
         VkHw==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

What happens when cleanerd is interrupted while it's cleaning by
unmounting the drive, for example, and then mounted again? Does it
resume from the previous block or does it start from the beginning?
Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
