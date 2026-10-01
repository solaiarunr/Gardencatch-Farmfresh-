//
//  CashExchangeHistoryDetailsViewController.swift
//  Joysale_Swift
//

import UIKit

/// Cash Exchange detail — matches Figma "Cash Exchange Record"
class CashExchangeHistoryDetailsViewController: UIViewController {

    var cashExchangeId: Int = 0

    private let viewModel = MyExchangeViewModel()
    private let themeGreen = UIColor(named: "AppThemeColor") ?? UIColor(red: 0.18, green: 0.49, blue: 0.20, alpha: 1)
    private let pageBg = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
    private let keyColor = UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1)
    private let valueColor = UIColor.black
    private let lineColor = UIColor(white: 0.88, alpha: 1)
    private let headerGray = UIColor(white: 0.94, alpha: 1)

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let detailsStack = UIStackView()
    private let historyTableStack = UIStackView()
    private let shareButton = UIButton(type: .custom)
    private let downloadButton = UIButton(type: .custom)
    private let actionRow = UIStackView()
    private var actionRowHeightConstraint: NSLayoutConstraint?

    private var shareUrl: String = ""
    private var downloadUrl: String = ""
    private var receiptFileName: String = "cash_exchange_receipt.pdf"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = pageBg
        setupUI()
        loadDetails()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        // Figma: nav title = app name
        navigationController?.NavigationBarWithBackButtonAndTitle(
            title: APP_NAME,
            fColor: "whitecolor",
            fontName: UIFont(name: APP_FONT_REGULAR, size: 18),
            imageName: "detail_back",
            isLeft: true,
            vc: self,
            transparantView: false
        )
        NotificationCenter.default.addObserver(self, selector: #selector(barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: nil)
    }

    @objc private func barButtonAction(_ notification: Notification) {
        if let isLeft = notification.userInfo?["isLeft"] as? Int, isLeft != 1 {
            navigationController?.popViewController(animated: true)
        }
    }

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)

        contentStack.axis = .vertical
        contentStack.spacing = 12
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        // MARK: Cash Exchange Record
        let recordTitle = sectionTitle(getLanguage["cash_exchange_record"] ?? "Cash Exchange Record")
        contentStack.addArrangedSubview(recordTitle)

        let detailsCard = makeCard()
        detailsStack.axis = .vertical
        detailsStack.spacing = 0
        detailsStack.translatesAutoresizingMaskIntoConstraints = false
        detailsCard.addSubview(detailsStack)
        NSLayoutConstraint.activate([
            detailsStack.topAnchor.constraint(equalTo: detailsCard.topAnchor, constant: 14),
            detailsStack.leadingAnchor.constraint(equalTo: detailsCard.leadingAnchor, constant: 14),
            detailsStack.trailingAnchor.constraint(equalTo: detailsCard.trailingAnchor, constant: -14),
            detailsStack.bottomAnchor.constraint(equalTo: detailsCard.bottomAnchor, constant: -14)
        ])
        contentStack.addArrangedSubview(detailsCard)
        contentStack.setCustomSpacing(20, after: detailsCard)

        // MARK: Transaction History
        let historyTitle = sectionTitle(getLanguage["transaction_history"] ?? "Transaction History")
        contentStack.addArrangedSubview(historyTitle)

        let historyCard = makeCard()
        historyCard.clipsToBounds = true
        historyTableStack.axis = .vertical
        historyTableStack.spacing = 0
        historyTableStack.translatesAutoresizingMaskIntoConstraints = false
        historyCard.addSubview(historyTableStack)
        NSLayoutConstraint.activate([
            historyTableStack.topAnchor.constraint(equalTo: historyCard.topAnchor),
            historyTableStack.leadingAnchor.constraint(equalTo: historyCard.leadingAnchor),
            historyTableStack.trailingAnchor.constraint(equalTo: historyCard.trailingAnchor),
            historyTableStack.bottomAnchor.constraint(equalTo: historyCard.bottomAnchor)
        ])
        contentStack.addArrangedSubview(historyCard)

        // MARK: Bottom Share Link + Download (Figma)
        actionRow.axis = .horizontal
        actionRow.spacing = 12
        actionRow.distribution = .fillEqually
        actionRow.translatesAutoresizingMaskIntoConstraints = false
        actionRow.addArrangedSubview(shareButton)
        actionRow.addArrangedSubview(downloadButton)
        view.addSubview(actionRow)

        styleShareButton()
        styleDownloadButton()
        shareButton.addTarget(self, action: #selector(shareAct), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(downloadAct), for: .touchUpInside)

        // Hide details until API response
        scrollView.isHidden = true
        actionRow.isHidden = true

        NSLayoutConstraint.activate([
            actionRow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            actionRow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            actionRow.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -14),

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: actionRow.topAnchor, constant: -12),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
        let actionHeight = actionRow.heightAnchor.constraint(equalToConstant: 0)
        actionHeight.isActive = true
        actionRowHeightConstraint = actionHeight
    }

    private func sectionTitle(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: APP_FONT_BOLD, size: 16) ?? .boldSystemFont(ofSize: 16)
        label.textColor = valueColor
        return label
    }

    private func makeCard() -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 10
        card.layer.borderWidth = 1
        card.layer.borderColor = lineColor.cgColor
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.06
        card.layer.shadowOffset = CGSize(width: 0, height: 1)
        card.layer.shadowRadius = 3
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }

    private func styleShareButton() {
        shareButton.backgroundColor = .white
        shareButton.layer.cornerRadius = 8
        shareButton.layer.borderWidth = 1.5
        shareButton.layer.borderColor = themeGreen.cgColor
        shareButton.setTitleColor(themeGreen, for: .normal)
        shareButton.titleLabel?.font = UIFont(name: APP_FONT_REGULAR, size: 15) ?? .systemFont(ofSize: 15)
        let title = getLanguage["share_link"] ?? "Share Link"
        if let icon = UIImage(named: "ex_share")?.withRenderingMode(.alwaysTemplate) {
            shareButton.setImage(icon, for: .normal)
            shareButton.tintColor = themeGreen
            shareButton.setTitle(title, for: .normal)
            shareButton.semanticContentAttribute = .forceRightToLeft
            // Gap between title and trailing share icon
            shareButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
            shareButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        } else {
            shareButton.setTitle(title, for: .normal)
        }
    }

    private func styleDownloadButton() {
        downloadButton.backgroundColor = themeGreen
        downloadButton.layer.cornerRadius = 8
        downloadButton.clipsToBounds = true
        downloadButton.setTitleColor(.white, for: .normal)
        downloadButton.titleLabel?.font = UIFont(name: APP_FONT_REGULAR, size: 15) ?? .systemFont(ofSize: 15)
        let title = getLanguage["download"] ?? "Download"
        if let icon = UIImage(named: "ex_download")?.withRenderingMode(.alwaysTemplate) {
            downloadButton.setImage(icon, for: .normal)
            downloadButton.tintColor = .white
            downloadButton.setTitle(title, for: .normal)
            downloadButton.semanticContentAttribute = .forceRightToLeft
            // Gap between title and trailing download icon
            downloadButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
            downloadButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        } else {
            downloadButton.setTitle(title, for: .normal)
        }
    }

    private func loadDetails() {
        scrollView.isHidden = true
        actionRow.isHidden = true
        let userId = UserDefaultModule.shared.getUserData()?.user_id ?? ""
        Utility.shared.startAnimation(viewController: self)
        viewModel.cashExchangeHistoryDetails(
            user_id: userId,
            cash_exchange_id: cashExchangeId,
            onSuccess: { [weak self] success in
                guard let self = self else { return }
                Utility.shared.stopAnimation(viewController: self)
                if success, let result = self.viewModel.cashHistoryDetailsModel?.result {
                    self.bind(result)
                    self.scrollView.isHidden = false
                    self.updateActionRowVisibility(for: result.status)
                }
            },
            onFailure: { [weak self] _ in
                guard let self = self else { return }
                Utility.shared.stopAnimation(viewController: self)
            }
        )
    }

    private func updateActionRowVisibility(for status: String?) {
        let value = (status ?? "").lowercased()
        let showsActions = value == "success" || value == "successful" || value == "completed"
        actionRow.isHidden = !showsActions
        actionRowHeightConstraint?.constant = showsActions ? 48 : 0
    }

    private func bind(_ result: CashExchangeHistoryResultModel) {
        detailsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        historyTableStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let amountText: String
        if let amount = result.cashAmount {
            amountText = String(format: "$ %.2f", amount)
        } else {
            amountText = "-"
        }

        let statusColor = (result.status ?? "").lowercased() == "completed" ? themeGreen : valueColor

        // Cash Exchange Record rows from cashexchangedetails
        detailsStack.addArrangedSubview(makeDetailRow(key: "Transaction ID", value: result.transaction_id))
        detailsStack.addArrangedSubview(makeDetailRow(key: "Status", value: (result.status ?? "-").uppercased(), valueColor: statusColor))
        detailsStack.addArrangedSubview(makeDetailRow(key: "Product", value: result.productName))
        detailsStack.addArrangedSubview(makeDetailRow(key: "Quantity", value: "\(result.quantity ?? 0)"))
        detailsStack.addArrangedSubview(makeDetailRow(key: "Cash Amount", value: amountText))
        detailsStack.addArrangedSubview(makeDetailRow(key: "Buyer", value: result.buyerName))
        detailsStack.addArrangedSubview(makeDetailRow(key: "Seller", value: result.sellerName))
        detailsStack.addArrangedSubview(makeDetailRow(key: "Initiated", value: CashExchangeHistoryItemModel.formatTimestamp(result.createdAt)))
        let completedText: String
        if let completedAt = result.completedAt, completedAt > 0 {
            completedText = CashExchangeHistoryItemModel.formatTimestamp(completedAt)
        } else {
            completedText = "N/A"
        }
        detailsStack.addArrangedSubview(makeDetailRow(key: "Completed", value: completedText))

        historyTableStack.addArrangedSubview(makeHistoryHeader())
        let items = result.history ?? []
        for item in items {
            historyTableStack.addArrangedSubview(makeHistoryRow(item))
        }

        shareUrl = result.shareUrl ?? ""
        // Prefer receipt_url from cashexchangedetails for local download
        let receipt = result.receiptUrl ?? ""
        downloadUrl = !receipt.isEmpty ? receipt : (result.downloadUrl ?? "")
        let txnId = result.transaction_id ?? "\(result.cashExchangeId ?? 0)"
        receiptFileName = "cash_exchange_receipt_\(txnId).pdf"
    }

    /// Figma first table: Label (gray)  –  Value (bold / green for status)
    private func makeDetailRow(key: String, value: String, valueColor: UIColor? = nil) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let keyLabel = UILabel()
        keyLabel.text = key
        keyLabel.font = UIFont(name: APP_FONT_REGULAR, size: 14) ?? .systemFont(ofSize: 14)
        keyLabel.textColor = keyColor
        keyLabel.numberOfLines = 1
        keyLabel.translatesAutoresizingMaskIntoConstraints = false

        // Short gray dash between label & value (Figma)
        let dash = UILabel()
        dash.text = "–"
        dash.font = UIFont(name: APP_FONT_REGULAR, size: 14) ?? .systemFont(ofSize: 14)
        dash.textColor = UIColor(white: 0.75, alpha: 1)
        dash.textAlignment = .center
        dash.translatesAutoresizingMaskIntoConstraints = false

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont(name: APP_FONT_BOLD, size: 14) ?? .boldSystemFont(ofSize: 14)
        valueLabel.textColor = valueColor ?? self.valueColor
        valueLabel.numberOfLines = 1
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(keyLabel)
        container.addSubview(dash)
        container.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 36),

            keyLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            keyLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            keyLabel.widthAnchor.constraint(equalToConstant: 120),

            dash.leadingAnchor.constraint(equalTo: keyLabel.trailingAnchor, constant: 4),
            dash.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            dash.widthAnchor.constraint(equalToConstant: 14),

            valueLabel.leadingAnchor.constraint(equalTo: dash.trailingAnchor, constant: 10),
            valueLabel.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        return container
    }

    private func makeHistoryHeader() -> UIView {
        let row = UIView()
        row.backgroundColor = headerGray
        row.translatesAutoresizingMaskIntoConstraints = false

        let status = headerLabel("Status")
        let user = headerLabel("User")
        let date = headerLabel("Date")
        let stack = UIStackView(arrangedSubviews: [status, user, date])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(stack)

        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: 40),
            stack.topAnchor.constraint(equalTo: row.topAnchor),
            stack.bottomAnchor.constraint(equalTo: row.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -8)
        ])
        return row
    }

    private func headerLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: APP_FONT_BOLD, size: 13) ?? .boldSystemFont(ofSize: 13)
        label.textColor = valueColor
        label.textAlignment = .center
        return label
    }

    private func makeHistoryRow(_ item: CashExchangeHistoryItemModel) -> UIView {
        let row = UIView()
        row.backgroundColor = .white
        row.translatesAutoresizingMaskIntoConstraints = false

        let status = cellLabel((item.status ?? "").uppercased(), bold: true)
        let user = cellLabel(item.user ?? "-", bold: false)
        let date = cellLabel(item.date ?? "-", bold: false)

        let stack = UIStackView(arrangedSubviews: [status, user, date])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(stack)

        let v1 = verticalSep()
        let v2 = verticalSep()
        row.addSubview(v1)
        row.addSubview(v2)

        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: 42),
            stack.topAnchor.constraint(equalTo: row.topAnchor),
            stack.bottomAnchor.constraint(equalTo: row.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: row.trailingAnchor),

            v1.centerXAnchor.constraint(equalTo: status.trailingAnchor),
            v1.topAnchor.constraint(equalTo: row.topAnchor, constant: 8),
            v1.bottomAnchor.constraint(equalTo: row.bottomAnchor, constant: -8),
            v1.widthAnchor.constraint(equalToConstant: 1),

            v2.centerXAnchor.constraint(equalTo: user.trailingAnchor),
            v2.topAnchor.constraint(equalTo: row.topAnchor, constant: 8),
            v2.bottomAnchor.constraint(equalTo: row.bottomAnchor, constant: -8),
            v2.widthAnchor.constraint(equalToConstant: 1)
        ])
        return row
    }

    private func cellLabel(_ text: String, bold: Bool) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = bold
            ? (UIFont(name: APP_FONT_BOLD, size: 12) ?? .boldSystemFont(ofSize: 12))
            : (UIFont(name: APP_FONT_REGULAR, size: 12) ?? .systemFont(ofSize: 12))
        label.textColor = bold ? valueColor : keyColor
        label.textAlignment = .center
        return label
    }

    private func verticalSep() -> UIView {
        let v = UIView()
        v.backgroundColor = lineColor
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }

    @objc private func shareAct() {
        guard let url = URL(string: shareUrl), !shareUrl.isEmpty else { return }
        present(UIActivityViewController(activityItems: [url], applicationActivities: nil), animated: true)
    }

    @objc private func downloadAct() {
        guard !downloadUrl.isEmpty, let remoteURL = URL(string: downloadUrl) else { return }

        Utility.shared.startAnimation(viewController: self)
        downloadButton.isEnabled = false

        URLSession.shared.downloadTask(with: remoteURL) { [weak self] tempURL, response, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.downloadButton.isEnabled = true
                Utility.shared.stopAnimation(viewController: self)
            }

            guard error == nil, let tempURL = tempURL else {
                DispatchQueue.main.async {
                    self.showSimpleAlert(getLanguage["something_went_wrong"] ?? "Unable to download receipt.")
                }
                return
            }

            // Prefer server filename; fall back to receipt_*.pdf
            var fileName = self.receiptFileName
            if let http = response as? HTTPURLResponse,
               let disposition = http.allHeaderFields["Content-Disposition"] as? String,
               let range = disposition.range(of: "filename="),
               !disposition[range.upperBound...].isEmpty {
                let raw = String(disposition[range.upperBound...])
                    .trimmingCharacters(in: CharacterSet(charactersIn: "\"' "))
                if !raw.isEmpty { fileName = raw }
            } else if !remoteURL.lastPathComponent.isEmpty,
                      remoteURL.lastPathComponent.lowercased().hasSuffix(".pdf") {
                fileName = remoteURL.lastPathComponent
            }

            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let localURL = documents.appendingPathComponent(fileName)

            do {
                if FileManager.default.fileExists(atPath: localURL.path) {
                    try FileManager.default.removeItem(at: localURL)
                }
                try FileManager.default.moveItem(at: tempURL, to: localURL)
                DispatchQueue.main.async {
                    // Open Files picker so user can save PDF (On My iPhone / iCloud / Downloads)
                    if #available(iOS 14.0, *) {
                        let picker = UIDocumentPickerViewController(forExporting: [localURL], asCopy: true)
                        self.present(picker, animated: true)
                    } else {
                        let picker = UIDocumentPickerViewController(url: localURL, in: .exportToService)
                        self.present(picker, animated: true)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.showSimpleAlert(getLanguage["something_went_wrong"] ?? "Unable to save receipt.")
                }
            }
        }.resume()
    }

    private func showSimpleAlert(_ message: String) {
        let alert = UIAlertController(
            title: getLanguage["alert"] ?? "Alert",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: getLanguage["ok"] ?? "OK", style: .default))
        present(alert, animated: true)
    }
}
