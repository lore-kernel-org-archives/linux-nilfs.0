From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH v2, RESEND 01/10] kobject: introduce kobject_del_and_put()
Date: Mon, 20 Mar 2023 13:08:43 +0900
Message-ID: <e4b8012d-32df-e054-4a2a-772fda228a6a@opensource.wdc.com>
References: <20230320033436.71982-1-frank.li@vivo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1679285337; x=1710821337;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=f0RzrlZk36B8QlnIxOLMByV1TWNDOIMn6+7Rb8kJGp8=;
  b=nrxkh5QuMkBIeNyPGj152fgL0jPzr8hWcWECPgN05dS+ZQ5N9lpA4vWU
   fotQtzhi4nGp3G0nTbrQE+rejuoh4lWKWDKI5w7wbYeaPAFzkqF3ZRIA3
   7KW8hwPXLtqg6Y5J3v8ma2ue4dEKi/NWvPY3v+jEGpgB7LwrfLpHI7rrn
   7dFAN11f+YjBfv1T7hcwIWR/wB0iZy6ACrJmnG6U4gWiT65i3ttLRRJNh
   Du8RGx+4aS1+382KyLzEkTqt/NFhnM1whrUSx4mmViepuWaTvfQW9o7hS
   wS5xYOwBLXtVjxT21VCZCVM8zXI5/cDjMw/A6tH2T+zVrb/LezX7n/aQv
   g==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1679285331; x=1681877332; bh=f0RzrlZk36B8QlnIxOLMByV1TWNDOIMn6+7
        Rb8kJGp8=; b=esT6TiIT+uoup3kWnY3xrSB3cYopIRmWLNhiVbZ6b5Myup6B95z
        p61YIXMydR7cv+BOtazS96fyHYNv37OnHrWVo6KCl4jC5ieFCwmxLpn12eg4/ysM
        pS91jjTlyfK5IAAj0Q5zaqAOyizcA9mGTXR4Q9eq3vYIamyUJ8etCo+vOy9sjk7l
        p6COnj+QZSprV+wuLiGHG6enDxDehZbJdOfQd1HClGCeQ2lGXZdLd/Qb+7pT/ebA
        Y3GEWaET42Y/8pV3BDj2JZueEuXtNYDsemmR9wfaJ23SwWvVQpUoQVjpDABRoBk6
        y7rjMU3wwH/4BD2261pJ4P51bH/Uqaj+DNg==
Content-Language: en-US
In-Reply-To: <20230320033436.71982-1-frank.li@vivo.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yangtao Li <frank.li@vivo.com>, clm@fb.com, josef@toxicpanda.com, dsterba@suse.com, xiang@kernel.org, chao@kernel.org, huyue2@coolpad.com, jefflexu@linux.alibaba.com, jaegeuk@kernel.org, trond.myklebust@hammerspace.com, anna@kernel.org, konishi.ryusuke@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, richard@nod.at, djwong@kernel.org, naohiro.aota@wdc.com, jth@kernel.org, gregkh@linuxfoundation.org, rafael@kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On 3/20/23 12:34, Yangtao Li wrote:
> Hi all,
> 
> Out of consideration for minimizing disruption, I did not send the
> patchset to everyone. However, it seems that my consideration was
> unnecessary, so I CC'd everyone on the first patch. If you would
> like to see the entire patchset, you can access it at this address.
> 
> https://lore.kernel.org/lkml/20230319092641.41917-1-frank.li@vivo.com/

Hard to comment on patches with this. It is only 10 patches. So send everything
please.

> 
> Thx,
> Yangtao

-- 
Damien Le Moal
Western Digital Research

