From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 1/3] nilfs-utils: use _POSIX_MAX_INPUT
Date: Mon, 15 Jan 2018 17:29:05 +0900 (JST)
Message-ID: <20180115.172905.1512735601427209035.konishi.ryusuke@lab.ntt.co.jp>
References: <1515011303-8797-1-git-send-email-dev.kurt@vandijck-laurijssen.be>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dQKtnEBF+RDmstNWSTwjj0jmhzWFEFYq2H/UMf2gxoY=;
        b=Z/osgL2ymC8A0LplQ9HKh0E8yaxhuq5ljkH8e7IlYb9TJSw5kZ+2XkuQNMGu1fOlPm
         2X9AJJwNzSkhFR+ofcLpFYdF8av3p7/Dh0+olWbrRdu5gYSM3N7G6OJx8BWhEoBNKQnE
         hdsiNbbniqhHJsEezhCINLLHIAmqqcMt3HqTa/3nuldJKYEMXMnrNe7/uDGwow3MEIg5
         PQBxssrQiGxzjtD0QoTK5w67kxW2vzl9E1vaK6EqqdE8mDnaVA7wRUxFhUnIcS/8w0h6
         MianwYPWiAKeGfAXbsjZO7+tlH+I5GUfQwHbjI9K3tfw6AuTQuDovIXGc6Uswh0me9b8
         w2mg==
In-Reply-To: <1515011303-8797-1-git-send-email-dev.kurt-yI9piX4KPfawT/RRk36CISFp6vIno51x@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Kurt Van Dijck <dev.kurt-yI9piX4KPfawT/RRk36CISFp6vIno51x@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed,  3 Jan 2018 21:28:21 +0100, Kurt Van Dijck wrote:
> musl does provide _POSIX_MAX_INPUT, but no MAX_INPUT out of the box.
> This commit assigns _POSIX_MAX_INPUT to MAX_INPUT.
> 
> Signed-off-by: Kurt Van Dijck <dev.kurt-yI9piX4KPfawT/RRk36CISFp6vIno51x@public.gmane.org>

Thank you for submitting these changes.
Now all three patches are tested and applied to the nilfs-utils repo.

Regards,
Ryusuke Konishi

> ---
>  bin/rmcp.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/bin/rmcp.c b/bin/rmcp.c
> index 0140f56..6773912 100644
> --- a/bin/rmcp.c
> +++ b/bin/rmcp.c
> @@ -47,6 +47,11 @@
>  #include <limits.h>
>  #endif	/* HAVE_LIMITS_H */
>  
> +/* define MAX_INPUT for musl */
> +#ifndef MAX_INPUT
> +#define MAX_INPUT _POSIX_MAX_INPUT
> +#endif
> +
>  #include <errno.h>
>  #include "nilfs.h"
>  #include "parser.h"
> -- 
> 1.8.5.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
