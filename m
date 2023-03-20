From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH v2, RESEND 01/10] kobject: introduce kobject_del_and_put()
Date: Mon, 20 Mar 2023 16:26:00 +0900
Message-ID: <982b6aa9-4adb-acef-d9d7-9a1764a66213@opensource.wdc.com>
References: <e4b8012d-32df-e054-4a2a-772fda228a6a@opensource.wdc.com>
 <20230320071140.44748-1-frank.li@vivo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1679297169; x=1710833169;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PznhUX2rDF8uhJla7kd2cwVnZx5w5yiNB4r5BQcdnfM=;
  b=nv+UpsTzuexcheOatHRuzIXoGBFE2bCC8Y0HdE9hsJtvLQn/RcPS9E3c
   uXuQmTbq1FYvRknl7+LG/UIQCNxO9AwCZme6ADDnesJpD2lrwGKrZYdN9
   MYleDw6y9/sX9d376oNTWC8T6wCvyK70Bbdvv9N6R2rMrj6u/RyPV6VkR
   C9X3MMsM0OzIphp90Stii47GxTGduveTcXRztAYlpYE+ZDQAcEyl1RCJg
   acRKtEDR246Rv6oQkO/sLFTIHh62RV2wBTmhc9gOSaVkUcOSvw0b/BQH9
   nxD+6mUgkr6gBERKRJjZ1l0bORnYSJgk4c67MzD7vUKcCmYBSvtiiYrWP
   Q==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1679297167; x=1681889168; bh=PznhUX2rDF8uhJla7kd2cwVnZx5w5yiNB4r
        5BQcdnfM=; b=tEhaQ1QWlYcUATSxgbmC1Irjhy1iyCOONUyaK4zHJkCmEPDGLER
        2bZXp7uXoeN6RX3JCuajZywhfAJDoiQCLYJkObCkGj6gN3IG0YhXYgKyKzEh7jWM
        OqPz8kTfiyiU5LFataQwHHb0Sbff8iMojaicjEFH4uoIbhjfsq9W6NYYGCPzEgUr
        BAxViofGRKnKh0NBhnXzZWgoPGthoEyR7qdFamLve7TMT+hPEtcz8xU+LdNaTGxO
        NpcEOGrr0JDR74v3n42n2iISL8Vz0bKzh+gj1hMK7lBnM8bCMoI86PFZva038aHw
        bO7IcaXdozRFOsyM3oQ1/Qtj86vrWfVdz2g==
Content-Language: en-US
In-Reply-To: <20230320071140.44748-1-frank.li@vivo.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yangtao Li <frank.li@vivo.com>, clm@fb.com, josef@toxicpanda.com, dsterba@suse.com, xiang@kernel.org, chao@kernel.org, huyue2@coolpad.com, jefflexu@linux.alibaba.com, jaegeuk@kernel.org, trond.myklebust@hammerspace.com, anna@kernel.org, konishi.ryusuke@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, richard@nod.at, djwong@kernel.org, naohiro.aota@wdc.com, jth@kernel.org, gregkh@linuxfoundation.org, rafael@kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On 3/20/23 16:11, Yangtao Li wrote:
> Hi filesystem maintainers,
> 
>> Hard to comment on patches with this. It is only 10 patches. So send everything please.
> 
> If you are interested in the entire patchset besides Damien,
> please let me know. I'll resend the email later to cc more people.

Yes, I said I am interested, twice already. It is IMPOSSIBLE to review a patch
without the context of other patches before/after said patch. So if you want a
review/ack for zonefs, then send the entire series.

> 
> Thx,
> Yangtao

-- 
Damien Le Moal
Western Digital Research

