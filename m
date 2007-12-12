From: "Sivan Toledo" <stoledo-EfZU8u+QLuPpgkiH4x7ZXw@public.gmane.org>
Subject: Re: A question about segment sizes and alignment
Date: Wed, 12 Dec 2007 08:18:37 -0500
Message-ID: <196f72b10712120518j578d662eo8b3faa97d40338e9@mail.gmail.com>
References: <196f72b10712111059m2e813aa4ga02ce5ccef4ae1ba@mail.gmail.com>
	<200712120830.lBC8Uk9s032124@nuesun.nue.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
	bh=N9naMhtH7PsvG/u3F7qaQIUOA0ttBBzNX9epPy+qcWU=;
	b=gavEmM+ODb0O7mnezqCcA75Z5Rcs5XZ9FB//2vrXhUzEDuQizRXK5SjaiBTup8Zf511cpJpxaq3uIA8ay5JQ8sAhUo7HRYQ9c2k4hJRJmt8p2j4ZUSfZdi6GmFaX/DN8sMuYhZkr8SmNTsTkvuzs+j3g3oEiK+Qcps5KfAJiYgg=
In-Reply-To: <200712120830.lBC8Uk9s032124-vVVTaDpzuSIg7PIzrqgn9Q@public.gmane.org>
Content-Disposition: inline
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Content-Type: text/plain; charset="us-ascii"
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Many thanks. Sivan

On 12/12/07, amagai-sG5X7nlA6pw@public.gmane.org <amagai-sG5X7nlA6pw@public.gmane.org> wrote:
> Hi,
>
> > What is the segment size that NILFS uses?
> > Is it possible to tune the segment size, perhaps by changing constants
>
> You can specify the segmnent size by mkfs.nilfs2 -c and -B options.
> mkfs.nilfs2 [-b block-size] [-B blocks-per-segment] ...
>
> Default are:  block-size == 4096 (byte), blocks-per-segment == 2048,
> so, default segment size is 8Mbyte.
> (They are coded in util/sbin/mkfs/mkfs.h)
>
> > Are the segments aligned in the address space of the block device?
> > That is, if each segment is 1MB, say, do the first one start in
>
> Yes. So, user usable data blocks of the first segment may be some blocks
> shorter for boot block and super blocks.
>
> Amagai Yoshiji
>
> NILFS team, NTT
> http://www.nilfs.org/
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
>
