From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 08/31] block: share code between
 disk_check_media_change and disk_force_media_change
Date: Wed, 7 Jun 2023 10:26:50 +0200
Message-ID: <20230607-abhielt-kirschen-288e7a9a9fe4@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-9-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=0M0M30z2u+fglgWOMw3K+IgsVQPGa0lJUOxsFckoNYw=; b=mbM4mOLLqVk+0WRduFRYGRZEQn
 evNf2tzFgfkMVPQTW4PMtWXi7+2LyV5R3VHUSiGCBaqSJ84RNp08oEtaP8ji91BVTBYhWh0vaJlaQ
 77d35HL8+WLDikTKR3UL7vv1b2O48ZVxSZUHB9R3kaULJfAvkX5IcV5PAImqTas/9iE8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=0M0M30z2u+fglgWOMw3K+IgsVQPGa0lJUOxsFckoNYw=; b=hMtMm+j6cKxr2IgvpOrbrHQfbb
 hBSWZ+UKI71d4IvbGTmanXvbojQs9pF6D2xESEI2gWWdENrfA46aacDfOcnEzx24zcGAcpAFRBKc+
 i52adUQIQkF/haAXgE0NcFY+76OJNxj8QLL+sRNEEIGX8hrQlXV9+F4jYRPOpRn1dUs8=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1686126419;
 bh=Kl3XQ9PoGp9pTvNWEYEaCMqRkYInB2avmNbeu92C6zU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=rgcywzP+1oCMwlq0k2fRCPBZXdUZRn9J8LrJASSZ5i8ERKpLVi1lgtd0pJwqJB0W7
 D8wlIL49yepvEx4+n2MmT7Ru/Aj5siKdB0jHacl1CtCKl9pO0JR5AlsMNcP4+CHinp
 OPR0Amz34//UXpE4vCzXPXEgPCrc/4r0Ykl5ORkARbmB44ULuK5TjPuzNOZ8nQxJja
 fGuUjMxzGMLdLJSXdYGCnhXt1cV/9zOntJTs1hNqR0nhjGSgxERqeRaqheqynMWt/A
 ac1PW1JzvY8VShzgVMk8msTfO/mSWVq1Eb6Oegl+HSBogzogFDyzAMws4bWaCKrm0L
 32r0fwv3mAedA==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-9-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Christoph Hellwig <hch@lst.de>
Cc: Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org, Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>, dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>, Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>, linux-pm@vger.kernel.org, linux-um@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org, linux

On Tue, Jun 06, 2023 at 09:39:27AM +0200, Christoph Hellwig wrote:
> Factor the common logic between disk_check_media_change and
> disk_force_media_change into a helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>
