From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 07/23] btrfs: Convert
 extent_write_cache_pages() to use filemap_get_folios_tag()
Date: Fri, 2 Sep 2022 14:29:10 +0200
Message-ID: <20220902122910.GV13489@twin.jikos.cz>
References: <20220901220138.182896-1-vishal.moola@gmail.com>
 <20220901220138.182896-8-vishal.moola@gmail.com>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ZSh2REjiRAk/k5oPQg2yXZGh/unc7sc3tPapfoccmRI=; b=BeTvbR2jpkmT4+17w6ChUfUNHB
 5hpX6GP1+YprViYyuc9VnV5M3BPNaZ8CqHkounANEfupcNLblr4rhJaZIWH6zmv9KIWfpPH87MSPV
 xIu7T8+wSVMsog6E1rb0iVEcj9waUWTJrjXWC3luWP6gMDtcnu7tLzG1BTNUUf6v9+QY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Reply-To:Message-ID:
 Subject:Cc:To:From:Date:Sender:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=ZSh2REjiRAk/k5oPQg2yXZGh/unc7sc3tPapfoccmRI=; b=Q9WF2i7T9LH5hF6mLf6ClNbG5I
 X5cQJ6sl2VikE08i/ZZgr7OXbcQp3FEtZAQ6/7cO0SgvUcqIzmNJ0SiNDJGvlwm7ptDFxCoG4vR82
 YJlyu3SuuK5TwOJr0+JWxM5QTqOEvxGIaA9jU79636JGNOOzN5e4P1qGpB6RMoxjphDc=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1662122070;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ZSh2REjiRAk/k5oPQg2yXZGh/unc7sc3tPapfoccmRI=;
 b=wdEwtN3JZgc/dJfXvHTB2OuHq5iMMkwcvGadpvdtKl82JBp/CVm4q6hNc+Y/iWTf2Xz+aI
 YGNc8TruF0sa2O/2hm9jHou3PZrcjEVob/160cOGyJ77oxrhQEaONmpuSIM0yX+QUzatCh
 /RsJEpuKLTyOxrED2kdzlFs5ZvtVXAo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1662122070;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ZSh2REjiRAk/k5oPQg2yXZGh/unc7sc3tPapfoccmRI=;
 b=KENUHNHD48w8jrLxhOstCJQGwUAg1XngO63jvWwXMV9t3VvgwJ8T1JrqwXS/ustyoxYoL+
 euH2Gj9JTUuJQ1CQ==
Content-Disposition: inline
In-Reply-To: <20220901220138.182896-8-vishal.moola@gmail.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Thu, Sep 01, 2022 at 03:01:22PM -0700, Vishal Moola (Oracle) wrote:
> Converted function to use folios throughout. This is in preparation for
> the removal of find_get_pages_range_tag(). Now also supports large
> folios.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

Acked-by: David Sterba <dsterba@suse.com>
