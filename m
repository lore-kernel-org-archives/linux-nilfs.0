From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [PATCH 07/10] nilfs2: Convert nilfs_copy_back_pages() to use filemap_get_folios()
Date: Wed, 8 Jun 2022 01:10:53 +0900
Message-ID: <CAKFNMonLF+nEs7xi0t=Wy4tf7fttLZCL4v+AZGjDWvSYqmZiaw@mail.gmail.com>
References: <20220605193854.2371230-1-willy@infradead.org> <20220605193854.2371230-8-willy@infradead.org>
Mime-Version: 1.0
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Gf/LMdzQibmA3CQFIu++5apIgfZQUBK5B+qLCJdcj4=;
        b=UlIOhhRMP5WcJQ/zc/OiuB+lJTkLdYOOC2sp32tUMTA/O3i/rkc1ZAr+Jnb1VYWskV
         u05p+kDGel0dChhHcNMQJ3nWK9QM/AusSmrLoilAGAMq8P1Cg/bOJoeexeiBsy2GTk2F
         xVz0A6K871QbrFfNY0huAGfUWcdkRyXdofetnbhEzKFP4IxOMyQ0BEUlVV/2c2qB5QcA
         555PBTn0EZRhixi/yvufl6vbsxbyCY9hXpoiDGn8etsqPoI/JAhbz7JMw04rLSzr9ZHj
         Urd+yKShZEUZEf3WOAkzCDqqZ597u7goZccNJETiU8vkNdpHhHzGB9Qr5r5SMSwm00qh
         DfTg==
In-Reply-To: <20220605193854.2371230-8-willy@infradead.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, Linux MM <linux-mm@kvack.org>, linux-nilfs <linux-nilfs@vger.kernel.org>

On Mon, Jun 6, 2022 at 1:00 PM Matthew Wilcox (Oracle) wrote:
>
> Use folios throughout.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/nilfs2/page.c | 60 ++++++++++++++++++++++++------------------------
>  1 file changed, 30 insertions(+), 30 deletions(-)

Throughout, looks good to me.   Thank you so much for your great work.

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Ryusuke Konishi
