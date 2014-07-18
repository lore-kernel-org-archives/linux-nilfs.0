From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs_clean_segments: segment construction failed. (err=-2)
Date: Fri, 18 Jul 2014 11:58:32 +0400
Message-ID: <1405670312.2626.2.camel@slavad-CELSIUS-H720>
References: <53ABA8F3.3010606@gmail.com>
	 <A863805F-8398-42B1-9BEA-35D4425E2404@dubeyko.com>
	 <53ABB6F4.5050508@gmail.com> <1403789693.2609.14.camel@slavad-CELSIUS-H720>
	 <53ACF691.5090203@gmail.com> <1403850646.2588.4.camel@slavad-CELSIUS-H720>
	 <53BB4B8B.4060902@gmail.com> <1404806620.2656.8.camel@slavad-CELSIUS-H720>
	 <53BEB4B3.7000002@gmail.com> <53C8CEFB.2010202@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=DOHJqsyQuftFnzxY+GawDmkqyZIX47SHvou9CXfJApw=;
	b=jw322ho/kzxA6wOPS5Owmy9C6TxwkiBY95WDWV6zkujENHH0UWt1Vq1U+rMMSKTSW245xaMYIyO63hxXjzzR3S1duSclDf5QO68GjSkypuIZfYjaoV7jRNRlr5jLrGCN;
In-Reply-To: <53C8CEFB.2010202-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: dE <de.techno-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 2014-07-18 at 13:08 +0530, dE wrote:

[snip]
> This bug does not persist with 2048 block size.

Thank you for testing. This is the really important detail.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
