From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 0/7] Convert to filemap_get_folios_contig()
Date: Tue, 23 Aug 2022 19:02:03 +0100
Message-ID: <YwUWG73OkS+3Eelr@casper.infradead.org>
References: <20220816175246.42401-1-vishal.moola@gmail.com>
 <20220823172642.GJ13489@twin.jikos.cz>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=F7agJyyQPBoKNSgYn2p8RhiVuoRJhF3uXfjMiiS+Xls=; b=Wkq47664wvidT/E01+KEhjp+FD
        R/XHD8tSjJ7wbSR/mUYAeZLcN9Qztr4HbAaptjmHf13Xvc/HhezApMdO9elvyO4yJky2geT4qJGiw
        ETVjqHkgyGMdGpfM/33Fu3FbWJdqyfvE7Gomlu8XUsphUa3UHMz1vW6QuUX6itShiWHOgh4mGnADK
        YLDxjyt+6hcWU3rUXSjXdG6cQBEL2pNTZFjh++GgJJwfdeTjQ2/EajCeR3hrpA1nrARg48VXIBoRv
        OY5Z8UvCwBhsFnazcFBsKtMiFMSi83zfhtHu4mnNppp6ZoBJ+FcwKhqsvBLgMFWMPweTwDT8k1nEh
        EeOcNoqQ==;
Content-Disposition: inline
In-Reply-To: <20220823172642.GJ13489-1ReQVI26iDCaZKY3DrU6dA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dsterba-AlSwsSmVLrQ@public.gmane.org, "Vishal Moola (Oracle)" <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 23, 2022 at 07:26:42PM +0200, David Sterba wrote:
> I've tested the whole branch in my fstest setup, no issues found and
> did a light review of the code changes, looks ok as well.

Thanks!

> How do you want get the patches merged? As it's an API conversion I can
> ack it and let it go via the mm tree. So far there are no conflicts with
> our btrfs development patches, I assume it'll be a clean merge in the
> future too.

I was planning on taking this patch series through the pagecache tree;
it's in -next, so any problems will show up as conflicts there.
