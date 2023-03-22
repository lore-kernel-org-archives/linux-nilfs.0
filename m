From: Damien Le Moal <damien.lemoal-yzvPICuk2AC/Fx7ZUtofftBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v3 10/10] nilfs2: convert to kobject_del_and_put()
Date: Thu, 23 Mar 2023 08:36:59 +0900
Message-ID: <b81bd0d2-bf95-a3da-2fdf-a7d95600f370@opensource.wdc.com>
References: <20230322165905.55389-1-frank.li@vivo.com>
 <20230322165905.55389-9-frank.li@vivo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1679528221; x=1711064221;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rNEfSER4swwikeY50PtiH1QfqYxcG1VPN0FLVwTfQCk=;
  b=O2QWck6PMH//1X9cYC5cgmc1aoeVOBfYNRgA74V+NoxKsRrlZngWGKNb
   OCM2fmMLIbuBO2yZMUqpPQaHjDgGqqBia/nsJa2n7VASVS3Vl4vddOImh
   wYMsS6KwTGAVYGlFHPF9fs/gJ1/YHUKslJueVHpXOHIQX5RQT/drS3IQm
   Eh+djZ+ht2s+17IakjgWpKU58cZJ1S64B+liN4wqS2blgj+8d/If5l7AD
   gWv3KJ0/OnPZ6YsVQDkRMK9LXBf+66tiRXOBPwPI1ztj5glwsY1ka29I8
   BTCOtwg19KwSgKlubv2b/QYYHKGdmJ0OFVsPOkfH8Ge5zAzfN2Ze7VzRr
   Q==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1679528221; x=1682120222; bh=rNEfSER4swwikeY50PtiH1QfqYxcG1VPN0F
        LVwTfQCk=; b=gT5N7kqZT/kA++fyjWYaTTcnwsHIU+GxJKWEfPwzBiAuQVTWE/1
        /XSwnAsGDMRI/Y1Jhnkq1HUe07ZviACdSHwYBy3cPkogTD3aZzjZw6ZN5tHgpe9r
        rYmSGTTnjYGKPrZ9a/0zI/nDYVo83VcWkNqYbvWtD9gDfcaB5H7WHjvAP1w/VrrN
        nfP1vozO/wPTRIJQCGTxpM7ajlvBYy7MdKoeUoPGXS/c9SkgKFCicMwWBmhUsxmR
        1deI/MYdU9LPZjEUCSrqU5VLR4JGUe0MfWWt4ECMEUqLtwlqgFCm34sEU4T+mopP
        NIq5omYoOjp17FeDSPQj4xsIsoP7veSa97g==
Content-Language: en-US
In-Reply-To: <20230322165905.55389-9-frank.li-DGpbCiVdSXo@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yangtao Li <frank.li-DGpbCiVdSXo@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 3/23/23 01:59, Yangtao Li wrote:
> Use kobject_del_and_put() to simplify code.
> 
> Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> Cc: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Damien Le Moal <damien.lemoal-yzvPICuk2AC/Fx7ZUtofftBPR1lH4CV8@public.gmane.org>
> Signed-off-by: Yangtao Li <frank.li-DGpbCiVdSXo@public.gmane.org>

Reviewed-by: Damien Le Moal <damien.lemoal-yzvPICuk2AC/Fx7ZUtofftBPR1lH4CV8@public.gmane.org>

-- 
Damien Le Moal
Western Digital Research

