From: dE <de.techno-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs_clean_segments: segment construction failed. (err=-2)
Date: Mon, 21 Jul 2014 22:24:13 +0530
Message-ID: <53CD45B5.3000703@gmail.com>
References: <53ABA8F3.3010606@gmail.com>	 <A863805F-8398-42B1-9BEA-35D4425E2404@dubeyko.com>	 <53ABB6F4.5050508@gmail.com> <1403789693.2609.14.camel@slavad-CELSIUS-H720>	 <53ACF691.5090203@gmail.com> <1403850646.2588.4.camel@slavad-CELSIUS-H720>	 <53BB4B8B.4060902@gmail.com> <1404806620.2656.8.camel@slavad-CELSIUS-H720>	 <53BEB4B3.7000002@gmail.com> <53C8CEFB.2010202@gmail.com> <1405670312.2626.2.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        bh=GazeyW9F7VhJXbuCO3eA3Ys1acPBdN67Ok0V1NnTLzI=;
        b=QSRxhJCceEfS2FrCUMRdod66odKY/9vRZAuONhiJPxPkW6CggTHBDXLXWx1nOkfWG9
         VW+9CU8OazX4lEx3d5PW/uEQUa7UvcugJMulGEJ3nrLBidTwwuwEWCBeH1rjuW0nwGqn
         i2k5wWG8Ca+CM2rUkFzbKCEQWI8Euc+Mwch2y7tZDEuO7gs0xA6U00GRzHvlR/1paZQe
         T3N2MzhCa6b9Yf44uQYnybIrCwoYunYAL3v1l9lVOQWfrjllftbeCznlgQcyuHgLBFH6
         e4KXd8Z3RCnRwGQtp72H4Q5gGsNYTCpSjU3tvAs8l+r5rrZih0RjjbwZk0jmiTOvMLft
         mwaA==
In-Reply-To: <1405670312.2626.2.camel@slavad-CELSIUS-H720>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 07/18/14 13:28, Vyacheslav Dubeyko wrote:
> On Fri, 2014-07-18 at 13:08 +0530, dE wrote:
>
> [snip]
>> This bug does not persist with 2048 block size.
> Thank you for testing. This is the really important detail.
>
> Thanks,
> Vyacheslav Dubeyko.
>
>

Today I did hit this bug. But as you might have noticed, it took quiet a 
lot of time to hit it.

But after I hit this bugs, the FS was unusable. I had to reformat.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
