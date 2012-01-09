From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] mkfs.nilfs2: support -h command line option
Date: Mon, 09 Jan 2012 18:32:09 +0900 (JST)
Message-ID: <20120109.183209.179932258.ryusuke@osrg.net>
References: <1325779419-27781-1-git-send-email-dan@archlinux.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1325779419-27781-1-git-send-email-dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu,  5 Jan 2012 10:03:39 -0600, Dan McGee wrote:
> Signed-off-by: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
> ---
>  man/mkfs.nilfs2.8 |    9 +++++++++
>  sbin/mkfs/mkfs.c  |   25 ++++++++++++++++---------
>  2 files changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/man/mkfs.nilfs2.8 b/man/mkfs.nilfs2.8
> index f513994..b334142 100644
> --- a/man/mkfs.nilfs2.8
> +++ b/man/mkfs.nilfs2.8
> @@ -36,6 +36,9 @@ mkfs.nilfs2 \- create a NILFS2 filesystem
>  .IR feature [,...]
>  ]
>  [
> +.B \-h
> +]
> +[
>  .B \-q
>  ]
>  [
> @@ -77,6 +80,9 @@ mkfs.nilfs2 \- create a NILFS2 filesystem
>  .IR feature [,...]
>  ]
>  [
> +.B \-h
> +]
> +[
>  .B \-q
>  ]
>  [
> @@ -114,6 +120,9 @@ number of blocks per segment is 2048 (= 8MB with 4KB blocks).
>  .B \-c
>  Check the device for bad blocks before building the filesystem.
>  .TP
> +.B \-h
> +Display help message and exit.
> +.TP
>  .BI \-K
>  Keep, do not attempt to discard blocks at mkfs time (discarding blocks
>  initially is useful on solid state drives and sparse /
> diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
> index 870c682..9f6f9b7 100644
> --- a/sbin/mkfs/mkfs.c
> +++ b/sbin/mkfs/mkfs.c
> @@ -647,7 +647,7 @@ int main(int argc, char *argv[])
>  	write_disk(fd, di); /* Writing to the device */
>  
>  	close(fd);
> -	exit(0);
> +	exit(EXIT_SUCCESS);
>  }
>  
>  /*
> @@ -692,7 +692,7 @@ static void disk_scan(const char *device)
>  		args[i++] = device;
>  		args[i] = NULL;
>  		execv(badblocks, (char **)args);
> -		exit(1); /* reach only if failed */
> +		exit(EXIT_FAILURE); /* reach only if failed */
>  	} else if (pid != -1) {
>  		if (wait(&status) < 0)
>  			perr("Error: cannot wait child");
> @@ -973,7 +973,7 @@ static void parse_options(int argc, char *argv[])
>  	int c, show_version_only = 0;
>  	char *fs_features = NULL;
>  
> -	while ((c = getopt(argc, argv, "b:B:cKL:m:nqvO:P:V")) != EOF) {
> +	while ((c = getopt(argc, argv, "b:B:chKL:m:nqvO:P:V")) != EOF) {
>  		switch (c) {
>  		case 'b':
>  			blocksize = atol(optarg);
> @@ -985,6 +985,9 @@ static void parse_options(int argc, char *argv[])
>  		case 'c':
>  			cflag++;
>  			break;
> +		case 'h':
> +			usage();
> +			exit(EXIT_SUCCESS);
>  		case 'K':
>  			discard = 0;
>  			break;
> @@ -1015,6 +1018,7 @@ static void parse_options(int argc, char *argv[])
>  			break;
>  		default:
>  			usage();
> +			exit(EXIT_FAILURE);
>  		}
>  	}
>  
> @@ -1022,11 +1026,15 @@ static void parse_options(int argc, char *argv[])
>  		verbose = 0;
>  
>  	if ((optind == argc) && !show_version_only)
> +	{
> +		printf("%d %d\n", optind, argc);
>  		usage();
> +		exit(EXIT_FAILURE);
> +	}
>  
>  	if (show_version_only) {
>  		show_version();
> -		exit(0);
> +		exit(EXIT_SUCCESS);
>  	}
>  
>  	check_blocks_per_segment(blocks_per_segment);
> @@ -1049,11 +1057,10 @@ static void usage(void)
>  {
>  	fprintf(stderr,
>  		"Usage: %s [-b block-size] [-B blocks-per-segment] [-c] \n"
> -		"[-L volume-label] [-m reserved-segments-percentage] \n"
> -		"[-O feature[,...]] \n"
> -		"[-nqvKV] device\n",
> +		"       [-L volume-label] [-m reserved-segments-percentage] \n"
> +		"       [-O feature[,...]] \n"
> +		"       [-hnqvKV] device\n",
>  		progname);
> -	exit(1);
>  }
>  
>  static void show_version(void)
> @@ -1080,7 +1087,7 @@ static void perr(const char *fmt, ...)
>  	vfprintf(stderr, fmt, args);
>  	fprintf(stderr, "\n");
>  	va_end(args);
> -	exit(1);
> +	exit(EXIT_FAILURE);
>  }
>  
>  static void cannot_rw_device(int fd, const char *device, int rw)
> -- 
> 1.7.8.1

Applied, thank you.

Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
