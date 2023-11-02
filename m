Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A6CDC4332F
	for <linux-nilfs@archiver.kernel.org>; Thu,  2 Nov 2023 11:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347276AbjKBLKj (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Thu, 2 Nov 2023 07:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347433AbjKBLKi (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Thu, 2 Nov 2023 07:10:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BAD132
        for <linux-nilfs@vger.kernel.org>; Thu,  2 Nov 2023 04:10:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1174C433C7;
        Thu,  2 Nov 2023 11:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698923435;
        bh=Lld2/QQulB4Yn2BcKv8FAqMH+Gc+z+gXEqeqig3i8Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p58rEyCwgwUL7d0IYhAze1TP2WcUQJmL9vaaFurwM3U+BikZTaez9KI8fDUdZVexj
         btTtlXsr/lnOvpuiiHzXC2RwbHhiIJyc2fUcPYAg0e6abhKSz8AP3FctqHJA7X6ulu
         XjA73zjKvlWclFe8AQ/GUDf+xN1QzfWfy/u7x3nCHRlryoDuKYjd2rBPkXo3gQ9rgZ
         fotDaDtjIWNMNvXCjW5pBoLhC1wGhhSBb+qWLvRWldOd1wp3qpK/6N4vnrcZx540cr
         8u6aZjSaF/3E9v3Hs2AnCRSS1CrpPKwj20ffujpYWMkHib9UHUspKhqfbm3X4zIalh
         1MyQ2LhRZeOoA==
From:   Christian Brauner <brauner@kernel.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        linux-nilfs@vger.kernel.org
Subject: Re: [PATCH] nilfs2: simplify device handling
Date:   Thu,  2 Nov 2023 12:10:27 +0100
Message-Id: <20231102-hochnehmen-zerrt-3d37601f7dd6@brauner>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231101172739.8676-1-jack@suse.cz>
References: <20231101172739.8676-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1061; i=brauner@kernel.org; h=from:subject:message-id; bh=Lld2/QQulB4Yn2BcKv8FAqMH+Gc+z+gXEqeqig3i8Uk=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaQ6N8/fsFJn49SXm3kTfB9anLP2sj8yuydUtETswHouRuOf MzMCO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACaS956R4V5Rk6kO23SvWM1XBTeLTl zeGq4jp1O3i/PRJ3HvTTI5Fgx/hQ7ezBOpi1v3fEEH+3Vm0cll3lKHG7RueE4tDxab5ujFCAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

On Wed, 01 Nov 2023 18:27:39 +0100, Jan Kara wrote:
> We removed all codepaths where s_umount is taken beneath open_mutex and
> bd_holder_lock so don't make things more complicated than they need to
> be and hold s_umount over block device opening.
> 
> 

Ah, thank you, Jan. I missed nilfs indeed!

---

Applied to the vfs.super branch of the vfs/vfs.git tree.
Patches in the vfs.super branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.super

[1/1] nilfs2: simplify device handling
      https://git.kernel.org/vfs/vfs/c/c6a4738de282
