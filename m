From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: Naming of tag operations in the XArray
Date: Mon, 18 Dec 2017 16:16:11 -0800
Message-ID: <b337fe8a-ca53-5e00-cf85-a8c385b494cc@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
 <20171206004159.3755-9-willy@infradead.org>
 <66ad068b-1973-ca41-7bbf-8a0634cc488d@infradead.org>
 <20171215042214.GA17444@bombadil.infradead.org>
 <20171215123417.GA10348@bombadil.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=++oKlaV5m0/Qh0o0Tbem5UeaFokgNgrUmT8xaGXys4E=; b=Bbu5fwwAuk3yLi9V/UXTdsw3OG
        3Pxr2gnTIydK9tIr6efek+ko0o3YfcJM9+6WYlonSnsI1phrpJu8heSv4xlRcwdJfa97NqnG0mIxt
        jqbeQufPpcdpgDmw2FZAd/zviph1XEje7cxY1H44odiHZbU3Gcm5IlIZfTJJLRWNuwmzdGFVw408y
        dtBXEDgEQCkKBoGv/XQ4d1El7IHpaoEehe2MkqfNOvm2siGNYCgoaods+puYe8qUJkZxxeVQ8GM2R
        uWev8B9qbVhUz100sffE1JbNTs50xQRCSxHcCwMNgiPdwnTASZoxxWd+GkHoRiq9vW/sXqkbaJWyS
      
In-Reply-To: <20171215123417.GA10348-PfSpb0PWhxZc2C7mugBRk2EX/6BAtgUQ@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Rehas Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 12/15/2017 04:34 AM, Matthew Wilcox wrote:
> On Thu, Dec 14, 2017 at 08:22:14PM -0800, Matthew Wilcox wrote:
>> On Mon, Dec 11, 2017 at 03:10:22PM -0800, Randy Dunlap wrote:
>>>> +A freshly-initialised XArray contains a ``NULL`` pointer at every index.
>>>> +Each non-``NULL`` entry in the array has three bits associated with
>>>> +it called tags.  Each tag may be flipped on or off independently of
>>>> +the others.  You can search for entries with a given tag set.
>>>
>>> Only tags that are set, or search for entries with some tag(s) cleared?
>>> Or is that like a mathematical set?
>>
>> hmm ...
>>
>> "Each tag may be set or cleared independently of the others.  You can
>> search for entries which have a particular tag set."
>>
>> Doesn't completely remove the ambiguity, but I can't think of how to phrase
>> that better ...
> 
> Thinking about this some more ...
> 
> At the moment, the pieces of the API which deal with tags look like this:
> 
> bool xa_tagged(const struct xarray *, xa_tag_t)
> bool xa_get_tag(struct xarray *, unsigned long index, xa_tag_t);
> void xa_set_tag(struct xarray *, unsigned long index, xa_tag_t);
> void xa_clear_tag(struct xarray *, unsigned long index, xa_tag_t);
> int xa_get_tagged(struct xarray *, void **dst, unsigned long start,
>                         unsigned long max, unsigned int n, xa_tag_t);
> 
> bool xas_get_tag(const struct xa_state *, xa_tag_t);
> void xas_set_tag(const struct xa_state *, xa_tag_t);
> void xas_clear_tag(const struct xa_state *, xa_tag_t);
> void *xas_find_tag(struct xa_state *, unsigned long max, xa_tag_t);
> xas_for_each_tag(xas, entry, max, tag) { }
> 
> (at some point there will be an xa_for_each_tag too, there just hasn't
> been a user yet).
> 
> I'm always ambivalent about using the word 'get' in an API because it has
> two common meanings; (increment a refcount) and (return the state).  How

Yes, I get that.  But you usually wouldn't lock a tag AFAIK.

> would people feel about these names instead:

I think that the original names are mostly better, except I do like
xa_select() instead of xa_get_tagged().  But even that doesn't have
to change.

> bool xa_any_tagged(xa, tag);
> bool xa_is_tagged(xa, index, tag);
> void xa_tag(xa, index, tag);
> void xa_untag(xa, index, tag);
> int xa_select(xa, dst, start, max, n, tag);
> 
> bool xas_is_tagged(xas, tag);
> void xas_tag(xas, tag);
> void xas_untag(xas, tag);
> void *xas_find_tag(xas, max, tag);
> xas_for_each_tag(xas, entry, max, tag) { }
> 
> (the last two are unchanged)
> 


-- 
~Randy
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
