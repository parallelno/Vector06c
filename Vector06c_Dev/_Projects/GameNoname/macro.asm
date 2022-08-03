		.macro RRC_(i)
			.loop i
			RRC
			.endloop
		.endmacro

		.macro PUSH_B(i)
			.loop i
			PUSH B
			.endloop
		.endmacro

		.macro INR_D(i)
			.loop i
			INR D
			.endloop
		.endmacro

		.macro BORDER_LINE(borderColorIdx = 1)
			mvi a, PORT0_OUT_OUT
			OUT 0
			mvi a, borderColorIdx
			OUT 2
			lda scrOffsetY
			OUT 3
		.endmacro