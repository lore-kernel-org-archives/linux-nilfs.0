From: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Does nilfs2 do any in-place writes?
Date: Wed, 15 Jan 2014 11:44:52 +0100
Message-ID: <CAFvQSYSzpX_WpUi9KpGj0pZvzhw2mfzzOqcgdj9ripXAjipmtw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=yTn66UEkib+PEKsVKuREFR4ACBE8noFU2UYd+VdFH2Y=;
        b=y8zlxcLcGzwSqUqpzBh20iHfk47iRjo7JcCszyvErC77dqTd7lOp0mSY01T2cl6jPy
         xAwgVM8ni1E2stEa7tEYwHs0fB5jJdFmjbvWbVmao/uSigklHdvWuIqCZFKVyk64FlbU
         QLSg4QgsKdtfMsGJe6BfCQpQUMs2uXNbzbIE8+qCDvfFQhRjGxuMhkFXSCgPLvzGzLg2
         xmYf/DnHFQzWy79CD0TEBkwJqNPPoeUIWM3nU/FchRvoSS0cmgB5Lym+Rha71zznSshc
         jkSkkyCn6wvbcIJ1segACYw2qpxHKhqwsYE8Gc+XJZh6yYCQcbCLda2PUDqG71Q/hS+f
         IFEw==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

Recently my raspberry pi destroyed a 32GB SD card after only 4 days,
because that cheap SD card seemed to have issues with wear-leveling.
The areas where the ext4 journal was stored were no longer read- or writeable.

I wonder which write-access patterns nilfs2 does exhibit.
Are there any frequent in-place updates to statically positioned data
structures (superblock, translation tables, ...) or is the data mostly
written sequentially?

Thank you in advance, Clemens
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
