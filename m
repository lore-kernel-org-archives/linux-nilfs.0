From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [dm-devel] [PATCH 01/17] zonefs: use bio_alloc in
 zonefs_file_dio_append
Date: Tue, 26 Jan 2021 23:23:15 +0000
Message-ID: <BL0PR04MB65145D02027D58CAF3F59626E7BC9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210126145247.1964410-1-hch@lst.de>
 <20210126145247.1964410-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=MIME-Version:Content-Transfer-Encoding:Content-Type
 :References:Message-ID:Date:Subject:CC:To:From:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:In-Reply-To:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=DT8br6vz/nOOn/SezbAG3agpr8MhS4DjGU3jfMYuX/c=; b=Qxg/Gog9sNNn+Z5OiMMmV17RCi
 7h6tYkqAl/akqeaLbygRr+XSoCuBQbtXVbL467o5nyB2mfbaWti6jbF1/VB0j+iXZ1L9FgcPn0IQC
 XqPRNTVLmF2mnEQ/EcxKuhJ46sHWKfSA3oI/E3GLr2ajLOOxrX1hLXEimEXysQisQRBw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:Message-ID
 :Date:Subject:CC:To:From:Sender:Reply-To:Content-ID:Content-Description:
 Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
 In-Reply-To:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
 List-Owner:List-Archive; bh=DT8br6vz/nOOn/SezbAG3agpr8MhS4DjGU3jfMYuX/c=; b=F
 WYEsIrTZ7LTwfpxkPuX+T/2qCfANzp7aaH5Eid5VVvQJl+z1pdY4GIFzhoxemPHEcOUaUwRmtV9Ow
 Y0JaDa9ScnT96aUeO6ILGFGixI2iWSzyAJXdFp1XkvFUpBoGsKoKW9C9CEfWudpvaq/LZY1uviy9v
 5YltXpkZMhmUhvak=;
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
 d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
 t=1611704621; x=1643240621;
 h=from:to:cc:subject:date:message-id:references:
 content-transfer-encoding:mime-version;
 bh=mTnNOaMvhWmSpCd7MNBWRJxVKCJ235YDnMqY4qDrjlg=;
 b=qeOsMTePm2PvWOuMbeBbalcAuyXQLIRoJL5jbpcDPaYy2/Zz+vXC98k5
 +/haCXa39A3xkd92s+JT5HihG/Xp13TOpbWRPg+bpCP4vpeE+S0XfD7Kq
 2vi4lBsg0MCZbZhTlmZIlW9cGpv2zYruGDqR6lP+gLAU5GYN+kdip00tm
 diq/MVQXW4zDF8iVwudBOU+2O4/txz7/fErwVSv6bN/UUZIQ51nz4bYUL
 /TYGOjQvxZVVNBqZV4vLww89N37MgKHtXtjXLT+ELcfIdX9WTaGX0RdRc
 xWlpqGDtTvdypkeXvEh9+fxkO9eWma7pF+W+cBIHYC9iteOST+JYAQXDy A==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DT8br6vz/nOOn/SezbAG3agpr8MhS4DjGU3jfMYuX/c=;
 b=Tx18zRFy4C7/LLfZjiC2xYNq9vYqLVmtds3ZXIly6Pkbb7rooc87Vv0ThAVno8Ww+urBcp/0bbimTFQl7hf/7JFqW1bUySUlV9m1ePMEwNcYkeKPjHCNdA8MPOQpDagkwq7KBSS7E36KqzwTKiTxpMh7eNlXaQ8IkvBbHhNEmmQ=
Content-Language: en-US
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Naohiro Aota <Naohiro.Aota@wdc.com>, "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, David Sterba <dsterba@suse.com>, "drbd-dev@tron.linbit.com" <drbd-dev@tron.linbit.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Lars Ellenberg <lars.ellenberg@linbit.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, Philipp Reisner <philipp.reisner@linbit.com>, "linux-f2fs-devel@lists.sourceforge.net" <linux-f2fs-devel@lists.sourceforge.net>, linux-fsdevel@v

On 2021/01/26 23:58, Christoph Hellwig wrote:
> Use bio_alloc instead of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/zonefs/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index bec47f2d074beb..faea2ed34b4a37 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -678,7 +678,7 @@ static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
>  	if (!nr_pages)
>  		return 0;
>  
> -	bio = bio_alloc_bioset(GFP_NOFS, nr_pages, &fs_bio_set);
> +	bio = bio_alloc(GFP_NOFS, nr_pages);
>  	if (!bio)
>  		return -ENOMEM;
>  
> 

Acked-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research
